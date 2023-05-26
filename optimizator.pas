unit optimizator;

interface

uses System.SysUtils, System.Generics.Collections, System.Classes, Vcl.Dialogs,
  BVNItem, Generics.Defaults;

type
  TBvn = class
  private
    firstLine:String;
    BVInfo:TStringList;
    itemcount:integer;
    Items:TObjectList<TBvnItem>;
  public
    constructor Create(filename:TFileName; IMaxFileRecords:Integer); //парсинг данных
    destructor Destroy; override;
    function getFirstLine:String;
    procedure getBVInfo(sll:TStrings);
    procedure getBVNItemTextContent(numofrec:integer; tccc:TStrings);
    procedure setBVNItemID(nu:Integer; nID:integer);
    procedure resort;
    function getBVNItemPartnumber(numofrecc:integer):String;
    function getBVNItemComment(numofreccc:integer):String;
    procedure setBVNItemComment(nfrec:integer; scomment:string);
    function getBVNItemLong(numofre:integer):Integer;
    function getBVNItemQuantity(numofr:integer):Integer;
    procedure savetofile(filenames:TFileName);
    function getBVNCount:Integer;
    function getBVNItemID(numo:integer):Integer;
    procedure optimize(zagotovki:TDictionary<integer,integer>; cut:integer; modf:boolean; spravka:TStrings);
  end;

implementation



//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
///                                                                                                ///
///            Класс TBVN                                                                          ///
///                                                                                                ///
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

//в конструкторе парситься файл данных
constructor TBvn.Create(filename: TFileName; IMaxFileRecords:integer);
var f:TextFile;
    s:String;
    i, currentnum:integer;
    templist:TStringList;
    Item:TBVNItem;
    //priznak:integer;
begin
  inherited Create;
  if IMaxFileRecords<1 then
    raise ERangeError.Create('Неверное значение длинны считываемого файла '+IntTostr(IMaxFileRecords)+', проверьте ini');
  try
    AssignFile(f,filename);
    reset(f);
  except
    raise EInOutError.Create('Ошибка открытия файла данных');
  end;
  i:=0;
  // priznak:=0;
  itemcount:=0;
  currentnum:=0;
  templist:=TStringList.Create;  //создаём временный стринглист
  try
    Items:=TObjectList<TBVNItem>.Create(True);
    //цикл чтения строк файла
    while not EOF(F) do begin
      //я думаю, что при преобразовании класс исключения будет EConverError
      i:=i+1; //счётчик
      readln(f,s);
      //алгоритм парсинга
      if i=1 then firstLine:=s; //первая строка со служебной информацией
      //отделение служебной BVNINFO информации
      if pos('BVINFO',s)<>0 then begin
        if not Assigned(BVInfo) then BVInfo:=TStringList.Create;
       // inc(priznak);
        BVInfo.Add(s);
      end;
      //это не первая строка и не BVNINFO, а значит код программы, начинающийся с её номера
      if (i<>1) and (pos('BVINFO',s)=0) then begin
        if pos(' ',s)>0 then begin
          //получаем в itemcount номер текущей программы, к которой относится строка
          try
            itemcount:=StrToInt(copy(s, 1, pos(' ',s)-1));
          except
            //если строка идёт без номера - аварийно вываливаемся
            raise EConvertError.Create('Неверное содержание BVN-файла или он повреждён. Код 2');
          end;
          //если номер текущей программы "свежий", то...
          if itemcount<>currentnum then begin
            //если текущий номер 0, то это первая строка первой программы, её не добавляем
            if currentnum<>0 then begin
              Item:=TBVNItem.Create(templist);
              Items.Add(Item);
              templist.Clear;
            end;
            //переключатель
            currentnum:=itemcount;
            //похоже без эксперимента не получится...
            //ShowMessage(inttostr(itemcount));
          end;
          templist.Add(s); //добавляем строку в темплист
          //дополнительная проверка, чтобы добавить последний объект, как от неё избавится?
          if EOF(f) then begin
            Item:=TBVNItem.Create(templist);
            Items.Add(Item);
            //ShowMessage(inttostr(itemcount));
          end;
        end else raise EConvertError.Create('Неверное содержание BVN-файла. Код 1');
      end;

        //конец алгоритма парсинга
        if i>IMaxFileRecords then raise   ////защита от зацикливания
          EConvertError.Create('Файл данных содержит свыше '+IntTostr(IMaxFileRecords)+' строк. Файл большой или проверьте ini');
    end;
  finally
    templist.Free;        //убиваем временный стринглист
  end;

  try
    closefile(f);
  except
    raise EInOutError.Create('Ошибка закрытия файла данных');
  end;

end;
//конец конструктора


//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//Деструктор - уничтожение объекта BVN
destructor TBVN.Destroy;
begin
  BVInfo.Free;
  Items.Free;
  inherited;
end;
//конец деструктора

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//оптимизатор
procedure TBVN.optimize(zagotovki: TDictionary<integer,integer>; cut:integer; modf:boolean; spravka:TStrings);
var zz,xx,tt:TList<TPair<integer,integer>>;
    el:TPair<integer,integer>;
    ex:TPair<integer,String>;
    Comparison, Comparison1:TComparison<TPair<integer,integer>>;
    temp:String;
    outt,raskroi:TList<TPair<Integer, String>>;
    i,k,j,ostatok,iterations,ostatok2,minkey,minostatok,zagminostatok:integer;
    firstmin,lastmin,firstitem,lastitem,keyzag,m,n:integer;
    uspeh:boolean;
begin
  //функция сортировки по убыванию длинны изделия
  Comparison:=
    function(const Left, Rigth: TPair<integer,integer>): integer
    begin
      Result:=Rigth.Value-Left.Value;
    end;
  //функция сортировки по убыванию длинны заготовки
  Comparison1:=
    function(const Left, Rigth: TPair<integer,integer>): integer
    begin
      Result:=Rigth.Key-Left.Key;
    end;
  //конец функций сортировки
  xx:=TList<TPair<integer,integer>>.Create(TComparer<TPair<integer,integer>>.Construct(Comparison));  //изделия
  zz:=TList<TPair<integer,integer>>.Create(TComparer<TPair<integer,integer>>.Construct(Comparison1)); //заготовки
  outt:=TList<TPair<integer, string>>.Create; //временный выходной список
  tt:=TList<TPair<integer, integer>>.Create; //временный список, для оптимизации каждой заготовки
  raskroi:=TList<TPair<integer, string>>.Create; //окончательный выходной список
  //временно используем TDictionary, поэтому копируем входной словарь из параметра в список заготовок
  //а наверное, не временно, так как создание и уничтожение словаря за телом процедуры, и управление памятью там-же
  for var Enum in zagotovki do zz.Add(Enum);
  //поехали дальше
  zz.Sort; //сортируем заготовку по убыванию длинны
  //блок освобождения ресурсов, при возникновении ошибки
  try
    //блок копирования изделий из поля-класса во входной список
    for var Enum in Items do begin
      if Enum.getQuantity>1 then
        raise EnotImplemented.Create('Количество изделий больше 1 пока не поддерживается');
      el.Key:=Enum.getID;
      el.Value:=Enum.getLong;
      xx.Add(el);
    end;
    xx.Sort; //сортируем изделия по убыванию длинны
    //проверяем на наличии исходных данных
    if xx.Count<1 then raise EArgumentException.Create('Нечего раскраивать');
    if zz.Count<1 then raise EArgumentException.Create('Нечем раскраивать');
    //цикл раскроя, пока не кончились изделия
    i:=0; //счётчик раскроя
    minostatok:=0; //инициализация для компилятора
    //пока входной список-изделий не очиститься полностью
    while xx.Count>0 do begin
      uspeh:=false;   //наличие хотя-бы одного раскроя
      if zz.Count<=0 then raise EArgumentException.Create('Заготовки кончились, а изделия нет');
      zagminostatok:=zz[0].Key; //минимальный остаток - длинна максимальной заготовки
      //попрыгай по заготовкам
      for k:=0 to zz.Count-1 do begin
        //очищаем временный входной список, перед сменой заготовки
        tt.Clear;
        for var Enum in xx do tt.Add(Enum); //копируем с основного списка во временный для раскроя k-ой заготовки
        //берём первый элемент и размещаем его в первой по длинне заготовке
        if ((tt[0].Value+cut)<zz[k].Key) and ((zz[k].Value>0) or (zz[k].Value=-999)) then begin
          //формируем новый элемент, в Key ID изделия
          ex.Key:=tt[0].Key;
          //в значении строка с номером заготовки
          ex.Value:='#'+IntToStr(i)+' в заг:'+inttostr(zz[k].Key)+' длин:'+inttostr(tt[0].Value)+' отп:'+inttostr(cut)
          +' остат:'+IntToStr(zz[k].Key-tt[0].Value-cut)+' F ';
          //вычисляем остаток и добавляем 1-й, самый длинный элемент во временный выходной список
          ostatok:=zz[k].Key-tt[0].Value-cut;
          outt.Add(ex);
          //Это наш первый элемент текущего раскроя во временном выходном списке
          firstitem:=outt.Count-1;
          tt.Delete(0);
          uspeh:=true; //как минимум, одна деталь раскроилась
          ///////////////////////////////////////////////////////////////////////////////////
          //некоторая модификация жадного алгоритма, мы накидываем деталей в текущий раскрой
          //сзади списка столько, сколько их влезет -1, последняя деталь будет с поиском минимального остатка
          if modf then begin
            iterations:=0;
            ostatok2:=ostatok;
            //узнаем сколько влезет мелких элементов в остаток
            for j := tt.Count-1 downto 0 do begin
              iterations:=iterations+1;
              ostatok2:=ostatok2-tt[tt.Count-iterations].Value-cut;
              if ostatok2<0 then break;
            end;  
            //добавляем в раскрой все мелкие элементы, котторые влезли, кроме последнего
            for j := 1 to iterations-2 do begin
              ex.Key:=tt[tt.Count-j].Key;
              ostatok:=ostatok-tt[tt.Count-j].Value-cut;
              ex.Value:='#'+IntToStr(i)+' в заг:'+inttostr(zz[k].Key)+' длин:'+IntToStr(tt[tt.Count-j].Value)+
              ' отп:'+inttostr(cut)+' остат:'+IntToStr(ostatok)+' M ';
              outt.Add(ex);
              tt.Delete(tt.Count-j);
              if tt.Count<=0 then break;
            end;
          end;
          //ищем оптимальное размещение последнего элемента, если он не единственный
          if tt.Count>0 then minostatok:=ostatok-tt[tt.Count-1].Value-cut;
          minkey:=0; //если найден такой элемент, то минкей будет не равен 0
          for j := 1 to tt.Count-1 do begin
            ostatok2:=ostatok-tt[tt.Count-j].Value-cut;
            if (ostatok2<=minostatok) and (ostatok2>0) then begin
              minostatok:=(ostatok-tt[tt.Count-j].Value-cut);
              minkey:=tt.Count-j;
            end;
            //так как список отсортирован по возрастанию, при появлении минуса, дальше идти не нужно
            if ostatok2<0 then break;
          end;
          //оптимальное размещение найдено
          if minkey<>0 then begin
            ex.Key:=tt[minkey].Key;
            ostatok:=ostatok-tt[minkey].Value-cut;
            ex.Value:='#'+IntToStr(i)+' в заг:'+inttostr(zz[k].Key)+' длин:'+IntToStr(tt[minkey].Value)+
            ' отп:'+inttostr(cut)+' остат:'+IntToStr(ostatok)+' O ';
            outt.Add(ex);
            tt.Delete(minkey);
            if tt.Count<=0 then break;
          end;
          ///////////////
        end else break; //изделие max не входит в заготовку k, дальше заготовки меньше - стоп
        lastitem:=outt.Count-1;
        //поиск заготовки-раскроя с минимальным отходом, при выходе по break она уже найдена
        if ostatok<=zagminostatok then begin
           zagminostatok:=ostatok;
           //начальная и конечная позиции оптимального раскроя в выходном списке
           firstmin:=firstitem;
           lastmin:=lastitem;
           //позиция оптимально раскроенной заготовки
           keyzag:=k;
        end;
      end;
      //конец цикла по заготовкам
      //ни одной детали не раскроилось в цикле по заготовкам
      if not uspeh then raise EArgumentException.Create('Изделие не влезает в самую большую заготовку');
      //привидения основных, входных и выходных списков к правильному виду,
      //так как мы нашли оптимально-раскраиваемую заготовку
      for k := firstmin to lastmin do begin
        //ну ка проверим
        if k=lastmin then begin
          ex:=outt[k];
          ex.Value:=ex.Value+' послостаток:'+inttostr(zagminostatok)+' %: '
          +floattostrf(((zagminostatok/zz[keyzag].Key)*100),FFfixed,3,2);
          outt[k]:=ex;
        end;
        //ну ка
        //тест
          ex:=outt[k];
          ex.Value:=inttostr(i+1)+'-'+inttostr(k-firstmin+1)+' '+inttostr(zz[keyzag].Key)+' |'
          +inttostr(ex.Key)+'| '+ex.Value;
          outt[k]:=ex;
        //тест
        raskroi.Add(outt[k]); //добавляем в выходной раскрой, оптимальный
        //удаляем из цикла входных элементов, те что в раскрое
        for j:=0 to xx.Count-1 do
           if xx[j].Key=outt[k].Key
              then begin
                //как только нашли элемент - прервали цикл
                xx.Delete(j);
                break;
              end;
      end;
      outt.Clear;
      //убираем раскраиваемую заготовку из списка заготовок, если не ключ бесконечности
      if zz[keyzag].Value<>-999 then begin
        el:=zz[keyzag];
        el.Value:=zz[keyzag].Value-1;
        zz[keyzag]:=el;
        if el.Value=0 then zz.Delete(keyzag);
      end;
      i:=i+1;
    end;
    //интерфейсная часть, для отладки
    for var Enum in raskroi do spravka.Add(Enum.Value);
    //попытка сортировки списка
    for m:=0 to raskroi.Count-1 do
      for n:=0 to Items.Count-1 do if raskroi[m].Key=items[n].getID then begin
        Items[n].setComment(raskroi[m].Value);
        Items.Move(n,m);
      end;
  finally
    outt.Free;
    zz.Free;
    xx.Free;
    tt.Free;
    raskroi.Free;
  end;
end;

//конец оптимизатора
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

//сохранение в файл
procedure TBVN.savetofile(filenames: TFileName);
var f1:TextFile;
    xxx:TStringList;
    i:integer;
begin
  assign(f1,filenames);
  rewrite(f1);
  xxx:=TStringList.Create;
  try
    writeln(f1,getfirstline);
    getBVInfo(xxx);
    for var Enum in xxx do writeln(f1,Enum);
    if Items.Count>1 then begin
      for i:=0 to Items.Count-1 do begin
        getBVNItemTextContent(i,xxx);
        for var Enum in xxx do writeln(f1,Enum);
      end;
    end;
  finally
    closefile(f1);
    xxx.Free;
  end;
end;

//геттеры и сеттеры
function TBVN.getFirstLine: string;
begin
  Result:=firstLine;
end;

procedure TBVN.getBVInfo(sll: TStrings);
begin
  if assigned(BVInfo) then sll.Assign(BVInfo);
end;

procedure TBVN.getBVNItemTextContent(numofrec: Integer; tccc: TStrings);
begin
  if assigned(Items) and assigned(Items[numofrec]) then Items[numofrec].getTextContent(tccc);
end;

function TBVN.getBVNItemPartnumber(numofrecc: Integer): string;
begin
  Result:=Items[numofrecc].getPartNumber;
end;

function TBVN.getBVNItemComment(numofreccc: Integer): string;
begin
  Result:=Items[numofreccc].getComment;
end;

function TBVN.getBVNItemLong(numofre: Integer): Integer;
begin
  Result:=Items[numofre].getLong;
end;

function TBVN.getBVNItemQuantity(numofr: Integer): Integer;
begin
  Result:=Items[numofr].getQuantity;
end;

function TBVN.getBVNCount: Integer;
begin
  Result:=Items.Count;
end;

function TBVN.getBVNItemID(numo: Integer): Integer;
begin
  Result:=Items[numo].getID;
end;

procedure TBVN.setBVNItemID(nu: Integer; nID: Integer);
var i:integer;
begin
  for i:=0 to Items.Count-1 do if Items[i].getID=nu then begin
   Items[i].setID(nID);
   break;
  end;
end;

procedure TBVN.setBVNItemComment(nfrec: Integer; scomment: string);
begin
  Items[nfrec].setComment(scomment);
end;

procedure TBVN.resort;
begin
  Items.Sort(TComparer<TBVNItem>.Construct(
  function (const L, R:TBVNItem):integer
  begin
    Result:=L.getID-R.getID;
  end
  ));
end;

end.

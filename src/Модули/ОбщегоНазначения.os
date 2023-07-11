﻿#Использовать tempfiles
#Использовать logos
#Использовать json
#Использовать fs
#Использовать "../Макеты"

// Вывод в лог
Перем Лог;

#Область ПрограммныйИнтерфейс

// Завершает работу приложения по PID
//
// Параметры:
//	Идентификатор - Число - PID процесса
//
Процедура ЗавершитьПроцессПоИдентификатору(Знач Идентификатор) Экспорт

	Процесс = НайтиПроцессПоИдентификатору(Идентификатор);
	Если ЗначениеЗаполнено(Процесс) Тогда
		Процесс.Завершить();
		Лог.Информация("Процесс с PID %1 завершен", Идентификатор);
	Иначе
		Лог.Предупреждение("При попытке завершить с PID %1 он не найден", Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

// Завершает работу процессов по имени
//
// Параметры:
//	ИмяПроцесса - Строка - имя процесса
//
Процедура ЗавершитьПроцессПоИмени(Знач ИмяПроцесса) Экспорт

	МассивПроцессов = НайтиПроцессыПоИмени(ИмяПроцесса);
	Для Каждого Процесс Из МассивПроцессов Цикл
		ЗавершитьПроцессПоИдентификатору(Процесс.Идентификатор);
	КонецЦикла;
	
КонецПроцедуры

// Полный путь
//
// Параметры:
//	Путь - Строка - исходный путь
//	КаталогПроекта - Строка - каталог проекта, если известен
//
// Возвращаемое значение:
//	Строка - полный путь по пути.
//
Функция ПолныйПуть(Знач Путь, Знач КаталогПроекта = "") Экспорт
	Перем ФайлПуть;

	Если ПустаяСтрока(Путь) Тогда
		Возврат Путь;
	КонецЕсли;

	Если ПустаяСтрока(КаталогПроекта) Тогда
		КаталогПроекта = КаталогПроекта();
		Лог.Отладка("Использован системный корневой путь проекта - <%1>", КаталогПроекта);
	КонецЕсли;

	Если Лев(Путь, 1) = "." И КаталогПроекта <> Путь Тогда
		Путь = ОбъединитьПути(КаталогПроекта, Путь);
		Лог.Отладка("Нашли абсолютный путь проекта - <%1>", Путь);
	КонецЕсли;

	ФайлПуть = Новый Файл(Путь);

	Возврат ФайловыеОперации.УдалитьПоследнийРазделительПути(ФайлПуть.ПолноеИмя);

КонецФункции // ПолныйПуть()

// Возвращает каталог текущего проекта
//
// Возвращаемое значение:
//	Строка - путь к корню этого проекта
//
Функция КаталогПроекта() Экспорт

	ФайлИсточника = Новый Файл(ТекущийСценарий().Источник);
	Результат = ОбъединитьПути(ФайлИсточника.Путь, "..", "..");
	Возврат ФайловыеОперации.АбсолютныйПуть(Результат);

КонецФункции

// Возвращает каталог макетов проекта
//
// Возвращаемое значение:
//	Строка - путь к макетам
//
Функция КаталогМакетов() Экспорт

	Результат = ОбъединитьПути(КаталогПроекта(), "src", "Макеты");
	Возврат ФайловыеОперации.АбсолютныйПуть(Результат);
	
КонецФункции

// Возвращает массив файлов с настройками
//
// Параметры:
//   Команда - КомандаПриложения - исходная команда.
//
// Возвращаемое значение:
//		Массив - массив существующих имен файлов настроек.
//
Функция ПолучитьФайлыНастроек(Знач Команда) Экспорт
	
	Массив = Новый Массив;
	ОпцияФайлНастроек = Команда.ЗначениеОпции("settings");
	Если ЗначениеЗаполнено(ОпцияФайлНастроек) Тогда
		ДобавитьСуществующийФайлВМассив(Массив, ОпцияФайлНастроек);
	КонецЕсли;
	
	// Настройки не переданы, либо не существует файл. Ищем любой файл, который есть в проекте с настройками
	Если Массив.Количество() = 0 Тогда

		КаталогПроекта = КаталогПроекта();

		ФайлНастроекБиблиотеки = ОбъединитьПути(КаталогПроекта, ПараметрыСистемы.ИмяФайлаНастроек());
		ФайлНастроекПроекта = ОбъединитьПути(КаталогПроекта, "..", ПараметрыСистемы.ИмяФайлаНастроек());

		ДобавитьСуществующийФайлВМассив(Массив, ФайлНастроекБиблиотеки);
		ДобавитьСуществующийФайлВМассив(Массив, ФайлНастроекПроекта);

	КонецЕсли;
	
	Возврат Массив;
	
КонецФункции // ПолучитьФайлыНастроек

// Записывает в файл JSON настройку
//
// Параметры:
//  ИмяФайла - Строка - Имя JSON файла
//  Ключ - Строка - Ключ в формате "Настройка1.Настройка2.Настройка3"
//  Значение - Строка - Произвольное значение
//
Процедура ЗаписатьНастройкуВФайл(Знач ИмяФайла, Знач Ключ, Знач Значение) Экспорт
		
	Если ФайловыеОперации.ФайлСуществует(ИмяФайла) Тогда
		НастройкиИзФайла = ПрочитатьФайлJSON(ИмяФайла);
	Иначе
		НастройкиИзФайла = Новый Соответствие();
	КонецЕсли;
	
	мНастройки = НастройкиИзФайла;
	Массив = СтроковыеОперации.РазложитьСтрокуВМассивПодстрок(Ключ, ".", Истина);
	Для Индекс = 0 По Массив.Количество() - 1 Цикл
		ИмяНастройки = Массив[Индекс];
		Если Индекс = Массив.Количество() - 1 Тогда
			мНастройки.Вставить(ИмяНастройки, Значение);
		Иначе
			Если мНастройки.Получить(ИмяНастройки) = Неопределено Тогда
				мНастройки.Вставить(ИмяНастройки, Новый Соответствие());
			КонецЕсли;
			мНастройки = мНастройки.Получить(ИмяНастройки);
		КонецЕсли;
	КонецЦикла;

	ЗаписатьФайлJSON(ИмяФайла, НастройкиИзФайла);

КонецПроцедуры

// Удалить из файла JSON настройку
//
// Параметры:
//  ИмяФайла - Строка - Имя JSON файла
//  Ключ - Строка - Ключ в формате "Настройка1.Настройка2.Настройка3"
//
Процедура УдалитьНастройкуИзФайла(Знач ИмяФайла, Знач Ключ) Экспорт
	
	Если ФайловыеОперации.ФайлСуществует(ИмяФайла) Тогда
		НастройкиИзФайла = ПрочитатьФайлJSON(ИмяФайла);
	Иначе
		Лог.Предупреждение("Файл с настройками не найден. Пропускаем удаление настройки");
		Возврат;
	КонецЕсли;

	мНастройки = НастройкиИзФайла;
	Массив = СтроковыеОперации.РазложитьСтрокуВМассивПодстрок(Ключ, ".", Истина);
	Для Индекс = 0 По Массив.Количество() - 1 Цикл
		ИмяНастройки = Массив[Индекс];
		Если мНастройки.Получить(ИмяНастройки) = Неопределено Тогда
			Лог.Предупреждение("Ключ ""%1"", не содержит части ключа ""%2""", Ключ, ИмяНастройки);
			Возврат;
		КонецЕсли;
		Если Индекс = Массив.Количество() - 1 Тогда
			мНастройки.Удалить(ИмяНастройки);
		Иначе
			мНастройки = мНастройки.Получить(ИмяНастройки);
		КонецЕсли;
	КонецЦикла;

	ЗаписатьФайлJSON(ИмяФайла, НастройкиИзФайла);

КонецПроцедуры

// Записывает в файл JSON настройку
//
// Параметры:
//  ИмяФайла - Строка - Имя JSON файла
//  Ключ - Строка - Ключ в формате "Настройка1.Настройка2.Настройка3"
//  Значение - Строка - Произвольное значение
//
Процедура ДобавитьНастройкуВМассивВФайл(Знач ИмяФайла, Знач Ключ, Знач Значение) Экспорт
		
	Если ФайловыеОперации.ФайлСуществует(ИмяФайла) Тогда
		НастройкиИзФайла = ПрочитатьФайлJSON(ИмяФайла);
	Иначе
		НастройкиИзФайла = Новый Соответствие();
	КонецЕсли;
	
	мНастройки = НастройкиИзФайла;
	Массив = СтроковыеОперации.РазложитьСтрокуВМассивПодстрок(Ключ, ".", Истина);
	Для Индекс = 0 По Массив.Количество() - 1 Цикл
		ИмяНастройки = Массив[Индекс];
		Если Индекс = Массив.Количество() - 1 Тогда
			Массив = Новый Массив();
			Если мНастройки.Получить(ИмяНастройки) <> Неопределено Тогда
				Массив = мНастройки.Получить(ИмяНастройки);
			КонецЕсли;
			Массив.Добавить(Значение);

			мНастройки.Вставить(ИмяНастройки, Массив);
		Иначе
			Если мНастройки.Получить(ИмяНастройки) = Неопределено Тогда
				мНастройки.Вставить(ИмяНастройки, Новый Соответствие());
			КонецЕсли;
			мНастройки = мНастройки.Получить(ИмяНастройки);
		КонецЕсли;
	КонецЦикла;

	ЗаписатьФайлJSON(ИмяФайла, НастройкиИзФайла);

КонецПроцедуры

// Записывает в файл JSON настройку
//
// Параметры:
//  ИмяФайла - Строка - Имя JSON файла
//	Действие - Перечисления.ДействияJSON - операция, которую надо выполнить
//  Ключ - Строка - Ключ в формате "Настройка1.Настройка2.Настройка3"
//  Значение - Строка - Произвольное значение
//
Процедура ВыполнитьДействиеJSON(Знач ИмяФайла, Знач Действие, Знач Ключ, Знач Значение = Неопределено) Экспорт

	Если Действие = Перечисления.ДействияJSON.УдалитьНастройку Тогда
		УдалитьНастройкуИзФайла(ИмяФайла, Ключ);
	ИначеЕсли Действие = Перечисления.ДействияJSON.ДобавитьВМассив Тогда
		ДобавитьНастройкуВМассивВФайл(ИмяФайла, Ключ, Значение);
	ИначеЕсли Действие = Перечисления.ДействияJSON.ОчиститьМассив Тогда
		УдалитьНастройкуИзФайла(ИмяФайла, Ключ);
		ЗаписатьНастройкуВФайл(ИмяФайла, Ключ, Новый Массив());
	Иначе
		ЗаписатьНастройкуВФайл(ИмяФайла, Ключ, Значение);
	КонецЕсли;

КонецПроцедуры

// Читает из файла JSON настройку
//
// Параметры:
//  ИмяФайла - Строка - Имя JSON файла
//  Ключ - Строка - Ключ в формате "Настройка1.Настройка2.Настройка3"
//	ВыдаватьОшибки - Булево - вывдавать ошибки в процессе чтения файла. По умолчанию Ложь
//
// Возвращаемое значение:
//	Произвольный, Неопределено - значение произвольного типа или Неопределено
//
Функция ПрочитатьНастройкуИзФайла(Знач ИмяФайла, Знач Ключ, Знач ВыдаватьОшибки = Ложь) Экспорт
		
	Если НЕ ФайловыеОперации.ФайлСуществует(ИмяФайла) Тогда
		Текст = СтрШаблон("Файл <%1> не найден, не удалось прочитать настройку", ИмяФайла);
		Если ВыдаватьОшибки Тогда
			ЗавершениеРаботыОшибка(Текст);
		Иначе
			Лог.Предупреждение(Текст);
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	Результат = ПрочитатьФайлJSON(ИмяФайла);
	
	Массив = СтроковыеОперации.РазложитьСтрокуВМассивПодстрок(Ключ, ".", Истина);
	Для Индекс = 0 По Массив.Количество() - 1 Цикл
		ИмяНастройки = Массив[Индекс];
		Результат = Результат.Получить(ИмяНастройки);
		Если НЕ ЗначениеЗаполнено(Результат) Тогда
			Если ВыдаватьОшибки Тогда
				ЗавершениеРаботыОшибка("В json-файле не найдено значение для ключа %1 (%2)", 
					Ключ, ИмяНастройки);
			КонецЕсли;

			Возврат Неопределено;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Функция - читает указанный макет JSON и возвращает содержимое в виде структуры/массива
//
// Параметры:
//	ИмяМакета    - Строка   - имя макета (файла) json
//
// Возвращаемое значение:
//	Структура, Массив       - прочитанные данные из макета
//
Функция ПрочитатьДанныеИзМакетаJSON(ИмяМакета) Экспорт
	
	Чтение = Новый ЧтениеJSON();
	
	ПутьКМакету = ПолучитьМакет(СтрШаблон("/Макеты/%1", ИмяМакета));
	
	Чтение.ОткрытьФайл(ПутьКМакету, КодировкаТекста.UTF8);
	
	Возврат ПрочитатьJSON(Чтение, Ложь);
	
КонецФункции // ПрочитатьДанныеИзМакетаJSON()

// Функция - читает указанный текстовый макет возвращает содержимое в виде строки
//
// Параметры:
//	ИмяМакета    - Строка   - имя макета (файла)
//
// Возвращаемое значение:
//	Строка       - прочитанные данные из макета
//
Функция ПрочитатьДанныеИзМакета(ИмяМакета) Экспорт
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ПутьКМакету = ОбъединитьПути(КаталогМакетов(), ИмяМакета);
	ТекстовыйДокумент.Прочитать(ПутьКМакету, КодировкаТекста.UTF8);
	Возврат ТекстовыйДокумент.ПолучитьТекст();
	
КонецФункции // ПрочитатьДанныеИзМакета()

&НаСервере
// Конвертирует JSON в Структуру.
//
// Параметры:
//	СтруктураВСтроке - Строка - строка JSON.
//	ВернутьСоответствие - Булево - вернуть в Соответствие если Истина, иначе в Структуру.
//
// Возвращаемое значение:
//	Структура - результат конвертации.
//
Функция JSONВСтруктуру(Знач СтруктураВСтроке, ВернутьСоответствие = Истина) Экспорт
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтруктураВСтроке);
	
	Возврат ПрочитатьJSON(ЧтениеJSON, ВернутьСоответствие);

КонецФункции

&НаСервере
// Конвертирует Структуру в JSON.
// 
// Параметры:
//  СтруктураЗначений - Структура - структура, которую необходимо конвертировать.
//  ПереносСтрок - Булево - Перенос строк JSON
// 
// Возвращаемое значение:
//  Строка - строка в формате JSON.
Функция СтруктураВJSON(Знач СтруктураЗначений, Знач ПереносСтрок = Ложь) Экспорт
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ПараметрПереносаСтрок = ?(ПереносСтрок = Истина, ПереносСтрокJSON.Авто, ПереносСтрокJSON.Нет);
	ПараметрыJSON = Новый ПараметрыЗаписиJSON(ПараметрПереносаСтрок);
	ЗаписьJSON.УстановитьСтроку(ПараметрыJSON);
	ЗаписатьJSON(ЗаписьJSON, СтруктураЗначений);
	ТекстJSON = ЗаписьJSON.Закрыть();
	
	Возврат ТекстJSON;
	
КонецФункции

// Читает текстовый файл по переданному пути, обертка для проверки существования файла.
//
//	Параметры:
//		Команда - КомандаПриложения - путь к файлу для чтения.
//		ВключатьГлавнуюКоманду - Булево - включать ли главную команду actions. По умолчанию Ложь.
//		ВключатьТекущуюКоманду - Булево - будет ли включена текущая команда в итоговый массив. По умолчанию Истина.
//
//	Возвращаемое значение:
//		Массив - массив строк, с родительскими командами/
//				Пример: введено "oscript src\actions.os zip add --file 1.md" => Массив[zip, add] 
//				(ВключатьГлавнуюКоманду = Ложь,	ВключатьТекущуюКоманду = Истина)
//
Функция РодительскиеКоманды(Знач Команда, Знач ВключатьГлавнуюКоманду = Ложь, 
	Знач ВключатьТекущуюКоманду = Истина) Экспорт

	Массив = Новый Массив;

	Для Каждого КомандаРодителя Из Команда.КомандыРодители Цикл
		ИмяКоманды = КомандаРодителя.ПолучитьИмяКоманды();
		Если ВключатьГлавнуюКоманду = Ложь И ИмяКоманды = ПараметрыСистемы.ИмяПриложения() Тогда
			Продолжить;
		КонецЕсли;
		Массив.Добавить(ИмяКоманды);
	КонецЦикла;

	Если ВключатьТекущуюКоманду = Истина Тогда
		Массив.Добавить(Команда.ПолучитьИмяКоманды());
	КонецЕсли;

	Возврат Массив;

КонецФункции

// Выводит переменную в консоль (Струкутура, Массив, Число и т.д.). Необходим для отладки.
//
// Параметры:
//	Значение    - Структура   - произвольная структура
//
Процедура ВывестиПеременнуюВКонсоль(Знач Значение) Экспорт

	Представление = Строка(ТипЗнч(Значение));
	Сообщить(ТекстВыводаВКонсоль(Представление, Значение));

КонецПроцедуры

// Поиск приложения в системе. Позволяет, 
// Использует переменные среды в ОС.
//
//	Параметры:
//		ИмяПриложения - Строка - краткое имя приложения (exe-файла). Лучше вызывать без расширения.
//
//	Возвращаемое значение:
//		Строка, Неопределено - полный путь к исходному файлу
//
// Пример:
//  НайтиПриложениеВСистеме("java") => "C:\Program Files\BellSoft\LibericaJDK-11-Full\bin\java.exe"
Функция НайтиПриложениеВСистеме(Знач ИмяПриложения) Экспорт

	ЭтоWindows = ЭтоWindows();
	НайденныйПуть = Неопределено;

	Команда = Новый Команда();

	Если ЭтоWindows Тогда
		Команда.УстановитьКоманду("where");
	Иначе
		Команда.УстановитьКоманду("whereis");
	КонецЕсли;
	Команда.ДобавитьПараметр(ИмяПриложения);

	КодВозврата = Команда.Исполнить();
	ВыводКоманды = Команда.ПолучитьВывод();

	Если КодВозврата = 0 Тогда
		НайденныйПуть = ВыводКоманды;
		Если НЕ ЭтоWindows Тогда
			НайденныйПуть = СтрЗаменить(НайденныйПуть, ИмяПриложения + ":", ""); 
			ЧастиСтроки = СтрРазделить(СокрЛП(НайденныйПуть), " ");
			НайденныйПуть = ЧастиСтроки[0];

			Если ПустаяСтрока(НайденныйПуть) Тогда
				НайденныйПуть = Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат НайденныйПуть;

КонецФункции

// Читает файл JSON и возвращает Структуру.
//
//	Параметры:
//		ИмяФайла - Строка - имя файла для чтения.
//
//	Возвращаемое значение:
//		Структура - выходная структура.
//
Функция ПрочитатьФайлJSON(Знач ИмяФайла) Экспорт

	Лог.Отладка("Читаю из json-файла %1", ИмяФайла);
	ФайлСуществующий = Новый Файл(ИмяФайла);
	Если НЕ ФайлСуществующий.Существует() Тогда
		Возврат Новый Соответствие;
	КонецЕсли;
	JsonСтрока = ПрочитатьФайл(ИмяФайла);
	
	ПарсерJSON = Новый ПарсерJSON();
	Результат = ПарсерJSON.ПрочитатьJSON(JsonСтрока);
	
	Возврат Результат;

КонецФункции

// Записать Структуру в файл JSON.
//
// Параметры:
//	ИмяФайла - Строка - имя файла для чтения.
//	Стуркутра - Стуркутра - структура, которую надо записать.
//
Процедура ЗаписатьФайлJSON(Знач ИмяФайла, Знач Стуркутра) Экспорт
	Лог.Отладка("Записываю json-файл %1", ИмяФайла);

	ПарсерJSON  = Новый ПарсерJSON();
	JsonСтрока = ПарсерJSON.ЗаписатьJSON(Стуркутра);
	Запись = Новый ЗаписьТекста;
	Запись.Открыть(ИмяФайла);
	Запись.Записать(JsonСтрока);
	Запись.Закрыть();

КонецПроцедуры

// Читает текстовый файл.
//
//	Параметры:
//		ИмяФайла - Строка - имя файла для чтения.
//		Кодировка - Строка, КодировкаТекста - кодировка файла.
//
//	Возвращаемое значение:
//		Строка - прочитанный файл.
//
Функция ПрочитатьФайл(Знач ИмяФайла, Знач Кодировка = Неопределено) Экспорт

	Лог.Отладка("Читаю из файла %1", ИмяФайла);
	Если НЕ ЗначениеЗаполнено(Кодировка) Тогда
		Кодировка = КодировкаТекста.UTF8;
	КонецЕсли;
	
	Чтение = Новый ЧтениеТекста(ИмяФайла, Кодировка, , , Ложь);
	Результат = Чтение.Прочитать();
	Чтение.Закрыть();
	
	Возврат Результат;
	
КонецФункции

// Читает ini-файл.
//
//	Параметры:
//		ИмяФайла - Строка - имя файла для чтения.
//		Кодировка - Строка, КодировкаТекста - кодировка файла.
//
//	Возвращаемое значение:
//		Структура - прочитанный файл.
//
// BSLLS:LatinAndCyrillicSymbolInWord-off
Функция ПрочитьIniФайл(Знач ИмяФайла, Знач Кодировка = Неопределено) Экспорт

    Результат = Новый Структура();
	Если НЕ ЗначениеЗаполнено(Кодировка) Тогда
		Кодировка = КодировкаТекста.UTF8;
	КонецЕсли;

    ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, Кодировка, , , Ложь);
    Лог.Отладка("Читаю ini-файл %1", ИмяФайла);
    Пока Истина Цикл
        Стр = ЧтениеТекста.ПрочитатьСтроку();
        Если Стр = Неопределено Тогда
            Прервать;
        КонецЕсли;
		Если ПустаяСтрока(Стр) Тогда
			Продолжить;
		КонецЕсли;
		Если СтрНачинаетсяС(Стр, "#") Тогда
			Продолжить;
		КонецЕсли;
		
        Лог.Отладка("Прочитано: " + Стр);
        Позиция = Найти(Стр, "=");
        Если Позиция = 0 Тогда
            Продолжить;
        КонецЕсли;

        Результат.Вставить(Лев(Стр, Позиция - 1), Сред(Стр, Позиция + 1));
        
    КонецЦикла;
    
    ЧтениеТекста.Закрыть();
    
    Возврат Результат;

КонецФункции
// BSLLS:LatinAndCyrillicSymbolInWord-on

// Завершает работу с переданным кодом возврата.
//
//	Параметры:
//		КодВозврата - Число - код возврата при завершении.
//
Процедура СистемноеЗавершениеРаботы(КодВозврата) Экспорт
	
	ВременныеФайлы.Удалить();
	ЗавершитьРаботу(КодВозврата);
	
КонецПроцедуры

// BSLLS:NumberOfParams-off
// BSLLS:MissingParameterDescription-off
// BSLLS:NumberOfOptionalParams-off

// Завершает работу приложения с ошибкой и выводом текста с параметрами.
//
// Параметры:
//		ТекстОшибки - Строка - строка с ошибкой.
//		Параметр1 - Произвольный - любой параметр
//		Параметр2 - Произвольный - любой параметр
//		Параметр3 - Произвольный - любой параметр
//		Параметр4 - Произвольный - любой параметр
//		Параметр5 - Произвольный - любой параметр
//		Параметр6 - Произвольный - любой параметр
//		Параметр7 - Произвольный - любой параметр
//		Параметр8 - Произвольный - любой параметр
//		Параметр9 - Произвольный - любой параметр
//
Процедура ЗавершениеРаботыОшибка(Знач ТекстОшибки, 
	Знач Параметр1 = Неопределено, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		Лог = ПараметрыСистемы.ПолучитьЛог();
		Лог.Ошибка(ТекстОшибки, 
			Параметр1, Параметр2, Параметр3,
			Параметр4, Параметр5, Параметр6,
			Параметр7, Параметр8, Параметр9);
	КонецЕсли;
	
	СистемноеЗавершениеРаботы(1);
	
КонецПроцедуры

// Завершает работу приложения с предупреждение и выводом текста.
//
// Параметры:
//		ТекстОшибки - Строка - строка с ошибкой.
//		Параметр1 - Произвольный - любой параметр
//		Параметр2 - Произвольный - любой параметр
//		Параметр3 - Произвольный - любой параметр
//		Параметр4 - Произвольный - любой параметр
//		Параметр5 - Произвольный - любой параметр
//		Параметр6 - Произвольный - любой параметр
//		Параметр7 - Произвольный - любой параметр
//		Параметр8 - Произвольный - любой параметр
//		Параметр9 - Произвольный - любой параметр
//
Процедура ЗавершениеРаботыПредупреждение(Знач ТекстПредупреждения, 
	Знач Параметр1 = Неопределено, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	
	Если НЕ ПустаяСтрока(ТекстПредупреждения) Тогда
		Лог = ПараметрыСистемы.ПолучитьЛог();
		Лог.Предупреждение(ТекстПредупреждения, 
			Параметр1, Параметр2, Параметр3,
			Параметр4, Параметр5, Параметр6,
			Параметр7, Параметр8, Параметр9);
	КонецЕсли;
	СистемноеЗавершениеРаботы(0);
	
КонецПроцедуры

// BSLLS:NumberOfOptionalParams-on
// BSLLS:MissingParameterDescription-on
// BSLLS:NumberOfParams-on

// Производит замену по регулярному выражению
//	Параметры:
//		ИсходнаяСтрока - Строка - исходная строка
//		РегулярноеВыражение - Строка - регулярное выражение
//		СтрокаЗамены - Строка - строка замены
// Возвращаемое значение:
//		Строка -	Строка с учетом замены.
// 					ЗаменитьПоРегулярномуВыражению("**жирный**", "(\*\*)(.*)(\*\*)", "<b>$2</b>") вернет <b>жирный</b>
// 					Подробнее о работе в: https://snegopat.ru/scripts/doc/trunk/rex/readme.markdown
Функция ЗаменитьПоРегулярномуВыражению(ИсходнаяСтрока, РегулярноеВыражение, СтрокаЗамены) Экспорт
	
	РегВыражение = Новый РегулярноеВыражение(РегулярноеВыражение);
	РегВыражение.ИгнорироватьРегистр = Истина;
	РегВыражение.Многострочный = Истина;
	Возврат РегВыражение.Заменить(ИсходнаяСтрока, СтрокаЗамены);
	
КонецФункции

// Производит поиск регулярного выражения в тексте и возвращает массив строк
//	Параметры:
//		ИсходнаяСтрока - Строка - исходная строка
//		РегулярноеВыражение - Строка - регулярное выражение
// Возвращаемое значение:
//		Массив - 	Массив с учетом реглулярного выражения.
//					НайтиПоРегулярномуВыражению("**жирный**", "\*\*(.*)\*\*") вернет массив из 1 элемента жирный
// 					Подробнее о работе в: https://snegopat.ru/scripts/doc/trunk/rex/readme.markdown
Функция НайтиПоРегулярномуВыражению(ИсходнаяСтрока, РегулярноеВыражение) Экспорт
	
	РегВыражение = Новый РегулярноеВыражение(РегулярноеВыражение);
	РегВыражение.ИгнорироватьРегистр = Истина;
	РегВыражение.Многострочный = Истина;
	Возврат РегВыражение.Разделить(ИсходнаяСтрока);
	
КонецФункции

// Производит поиск регулярного выражения в тексте и возвращает массив строк.
//
// Параметры:
//		Версия - Число - исходная версия.
//
// Возвращаемое значение:
//		Число	- вес версии в числовом выражении
Функция ВесВерсии(Знач Версия) Экспорт
	
	ПриведеннаяВерсия = ПривестиКВерсии(Версия);
	Если ПриведеннаяВерсия = "" Тогда
		Возврат 0;
	КонецЕсли;
	Результат = ВесВерсииИзМассиваСтрок(СтрРазделить(ПриведеннаяВерсия, "."));
	
	// "1.0.0.0" больше, чем "1.0.0.0 aplha"
	Если СтрДлина(ПриведеннаяВерсия) < СтрДлина(Версия) Тогда
		ШтрафЗаПостфикс = 0.5;
		Результат = Результат - ШтрафЗаПостфикс;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Приводит строку с версией и другими символами к строке, где есть только версия
//
// Параметры:
//	ВерсияСтрокой - Строка - исходная строка
//
// Возвращаемое значение:
//		Строка - строка только с символами 0123456789 и точкой. Пример: "1.0.0.5 alpha" => "1.0.0.5"
Функция ПривестиКВерсии(Знач ВерсияСтрокой) Экспорт
	
	Результат = "";
	Для Индекс = 1 По СтрДлина(ВерсияСтрокой) Цикл
		СимволСтроки = Сред(ВерсияСтрокой, Индекс, 1);
		Если СтрНайти("0123456789.", СимволСтроки) > 0 Тогда
			Результат = Результат + СимволСтроки;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает Истина, если текущая ОС - Windows.
//
// Возвращаемое значение:
//		Булево - Истина, если Windows, иначе Ложь.
Функция ЭтоWindows() Экспорт

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;
	Возврат ЭтоWindows;

КонецФункции

// Функция запускает отдельный процесс системы и дожидается его выполнения.
//	Параметры:
//		СтрокаВыполнения - Строка - строка для выполнения.
//
//	Возвращаемое значение:
//		Текст - текст со стандартным выводом процесса.
//
Функция ЗапуститьПроцесс(Знач СтрокаВыполнения) Экспорт
	Перем ПаузаОжиданияЧтенияБуфера;

	ПаузаОжиданияЧтенияБуфера = 10;

	Лог.Отладка(СтрокаВыполнения);
	Процесс = СоздатьПроцесс(СтрокаВыполнения, , Истина);
	Процесс.Запустить();

	ТекстБазовый = "";
	Счетчик = 0;
	МаксСчетчикЦикла = 100000;

	Пока Истина Цикл
		Текст = Процесс.ПотокВывода.Прочитать();
		Лог.Отладка("Цикл ПотокаВывода " + Текст);
		Если Текст = Неопределено ИЛИ ПустаяСтрока(СокрЛП(Текст))  Тогда
			Прервать;
		КонецЕсли;
		Счетчик = Счетчик + 1;
		Если Счетчик > МаксСчетчикЦикла Тогда
			Прервать;
		КонецЕсли;
		ТекстБазовый = ТекстБазовый + Текст;

		sleep(ПаузаОжиданияЧтенияБуфера); // Подождем, надеюсь буфер не переполнится.

	КонецЦикла;

	Процесс.ОжидатьЗавершения();

	Если Процесс.КодВозврата = 0 Тогда
		Текст = Процесс.ПотокВывода.Прочитать();
		Если Текст <> Неопределено И Не ПустаяСтрока(Текст) Тогда
			ТекстБазовый = ТекстБазовый + Текст;
		КонецЕсли;
		Лог.Отладка(ТекстБазовый);
		Возврат ТекстБазовый;
	Иначе
		ОписаниеОшибок = Процесс.ПотокОшибок.Прочитать();
		ВызватьИсключение СтрШаблон("Сообщение от процесса
									| код: %1 процесс: %2",
									Процесс.КодВозврата,
									ОписаниеОшибок);
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВесВерсииИзМассиваСтрок(РазрядыВерсииСтроками)
	
	Результат = 0;
	
	// Проверека, что массив пуст
	Если РазрядыВерсииСтроками.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Проверка, что версия не число
	Для Каждого Элемент Из РазрядыВерсииСтроками Цикл
		Если НЕ СтроковыеОперации.ТолькоЦифрыВСтроке(Элемент) Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	
	КоэффициентИндекс = 1;
	КоэффициентВерсии = 1000;
	Индекс = РазрядыВерсииСтроками.Количество() - 1;
	Пока Индекс >= 0 Цикл
		Результат = Результат + РазрядыВерсииСтроками[Индекс] * КоэффициентИндекс;
		Индекс = Индекс - 1;
		КоэффициентИндекс = КоэффициентИндекс * КоэффициентВерсии;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ДобавитьСуществующийФайлВМассив(Массив, Знач ИмяФайла)
	
	Если НЕ ПустаяСтрока(ИмяФайла)
		И ФайловыеОперации.ФайлСуществует(ИмяФайла)
		И Массив.Найти(ИмяФайла) = Неопределено Тогда
		
		Массив.Добавить(ИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры // ДобавитьСуществующийФайлВМассив()

Функция ТекстВыводаВКонсоль(Знач Имя, Знач Значение, Знач Сдвиг = 0)

	Результат = "";
	СтрокаСдвига = СтроковыеОперации.ДополнитьСтроку(Результат, Сдвиг, " ");

	Если ТипЗнч(Значение) = Тип("Массив") Тогда
		Результат = Результат + СтрШаблон("%1%2 (%3)", СтрокаСдвига, Имя, Строка(ТипЗнч(Значение))) + Символы.ПС;
		Для Индекс = 0 По Значение.Количество() - 1 Цикл
			Результат = Результат + ТекстВыводаВКонсоль(Строка(Индекс), Значение[Индекс], Сдвиг + 1);
		КонецЦикла;
	ИначеЕсли ТипЗнч(Значение) = Тип("Структура")
		ИЛИ ТипЗнч(Значение) = Тип("Соответствие") Тогда

		Результат = Результат + СтрШаблон("%1%2 (%3)", СтрокаСдвига, Имя, Строка(ТипЗнч(Значение))) + Символы.ПС;
		Для Каждого КлючЗначение Из Значение Цикл
			Результат = Результат + ТекстВыводаВКонсоль(КлючЗначение.Ключ, КлючЗначение.Значение, Сдвиг + 1);
		КонецЦикла;

	Иначе
		Результат = Результат + СтрокаСдвига + Имя + "=" + Строка(Значение) + Символы.ПС;
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

Лог = ПараметрыСистемы.ПолучитьЛог();
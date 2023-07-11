﻿#Использовать v8runner
#Использовать asserts
#Использовать v8storage
#Использовать ParserFileV8i
#Использовать logos

#Область ПрограммныйИнтерфейс

// Проверяет установку 1C
//
// Возвращаемое значение:
//	Булево - 1С установлена
//
Функция ПроверитьУстановку1C() Экспорт

	Конфигуратор = Новый УправлениеКонфигуратором();
	ПутьКПлатформе = Конфигуратор.ПолучитьПутьКВерсииПлатформы("8.3");

	Возврат НЕ ПустаяСтрока(ПутьКПлатформе);

КонецФункции

// Инициализирует параметры для прочих команд работы с 1С
//
// Возвращаемое значение:
//	Массив - массив строк всех параметров
//
Функция КонструкторОбщий() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("connection");
	Результат.Добавить("user");
	Результат.Добавить("password");
	Результат.Добавить("v8version");
	Результат.Добавить("uccode");	
	Возврат Результат;
	
КонецФункции

// Инициализирует параметры для создания файловой базы
//
// Возвращаемое значение:
//	Массив - массив строк всех параметров
//
Функция КонструкторСозданияДистрибутива() Экспорт
	
	Результат = КонструкторОбщий();
	Возврат Результат;
	
КонецФункции

// Инициализирует параметры для создания файловой базы
//
// Возвращаемое значение:
//	Массив - массив строк всех параметров
//
Функция КонструкторСозданияФайловойИБ() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("v8version");
	Результат.Добавить("language");
	Результат.Добавить("locale");
	Результат.Добавить("template");
	Результат.Добавить("basename");
	Возврат Результат;
	
КонецФункции

// Инициализирует параметры для создания серверной базы
//
// Возвращаемое значение:
//	Массив - массив строк всех параметров
//
Функция КонструкторСозданияСервернойИБ() Экспорт
	
	Результат = КонструкторСозданияФайловойИБ();
	Результат.Добавить("server");
	Результат.Добавить("ref");
	Результат.Добавить("dbms");
	Результат.Добавить("dbserver");
	Результат.Добавить("dbuser");
	Результат.Добавить("dbpassword");
	Результат.Добавить("dbname");
	Результат.Добавить("sqloffs");
	Результат.Добавить("createdb");
	Результат.Добавить("allowschjob");
	Результат.Добавить("allowlicdstr");
	Результат.Добавить("cadmuser");
	Результат.Добавить("cadmpassword");
	Возврат Результат;
	
КонецФункции

// Инициализирует параметры для выгрузки базы 1С в dt-файл
//
// Возвращаемое значение:
//	Массив - массив строк всех параметров
//
Функция КонструкторВыгрузкиИБ() Экспорт
	
	Результат = КонструкторОбщий();
	Результат.Добавить("file");
	Возврат Результат;
	
КонецФункции

// Инициализирует параметры для выгрузки базы 1С в dt-файл
//
// Возвращаемое значение:
//	Массив - массив строк всех параметров
//
Функция КонструкторDbgsOn() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("v8version");
	Возврат Результат;
	
КонецФункции

// Инициализирует параметры для выгрузки базы 1С в dt-файл
//
// Возвращаемое значение:
//	Массив - массив строк всех параметров
//
Функция КонструкторТестированиеВанесса() Экспорт
	
	Результат = КонструкторОбщий();
	Результат.Добавить("ordinaryapp");
	Возврат Результат;
	
КонецФункции

// Инициализирует параметры для очистки кэша 1С
//
// Возвращаемое значение:
//	Массив - массив строк всех параметров
//
Функция КонструкторОчисткиКэшаИБ() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("connection");
	Возврат Результат;
	
КонецФункции

// Инициализирует параметры для выгрузки базы 1С в dt-файл
//
// Возвращаемое значение:
//	Массив - массив строк всех параметров
//
Функция КонструкторПроверкиКонфигурации() Экспорт
	
	Результат = КонструкторОбщий();
	Возврат Результат;
	
КонецФункции

// Описывает ключи для запуска проверки конфигурации.
//
// Возвращаемое значение:
//	Структура - Ключ - это ключ проверки, значение - это описание проверки
//
Функция КлючиПроверкиКонфигурации() Экспорт

	// BSLLS:LineLength-off
	Структура = Новый Структура();
	Структура.Вставить("ThinClient", "Cинтаксический контроль модулей для режима эмуляции среды управляемого приложения (тонкий клиент), выполняемого в файловом режиме");
	Структура.Вставить("WebClient", "Cинтаксический контроль модулей в режиме эмуляции среды веб-клиента");
	Структура.Вставить("Server", "Синтаксический контроль модулей в режиме эмуляции среды сервера 1С:Предприятия");
	Структура.Вставить("ExternalConnection", "Синтаксический контроль модулей в режиме эмуляции среды внешнего соединения, выполняемого в файловом режиме");
	Структура.Вставить("ExternalConnectionServer", "Синтаксический контроль модулей в режиме эмуляции среды внешнего соединения, выполняемого в клиент-серверном режиме");
	Структура.Вставить("ThickClientManagedApplication", "Синтаксический контроль модулей в режиме эмуляции среды управляемого приложения (толстый клиент), выполняемого в файловом режиме");
	Структура.Вставить("ConfigLogIntegrity", "Логическая целостность конфигурации");
	Структура.Вставить("IncorrectReferences", "Поиск некорректных ссылок");
	Структура.Вставить("MobileClient", "Синтаксический контроль модулей в режиме эмуляции среды мобильного клиента");
	Структура.Вставить("MobileClientStandalone", "Синтаксический контроль модулей в режиме эмуляции среды мобильного клиента, работающего в автономном режиме");
	Структура.Вставить("MobileAppClient", "Синтаксический контроль модулей в режиме эмуляции среды мобильного приложения, выполняемого в клиентском режиме запуска");
	Структура.Вставить("MobileAppServer", "Синтаксический контроль модулей в режиме эмуляции среды мобильного приложения, выполняемого в серверном режиме запуска");
	Структура.Вставить("ThickClientServerManagedApplication", "Синтаксический контроль модулей в режиме эмуляции среды управляемого приложения (толстый клиент), выполняемого в клиент-серверном режиме");
	Структура.Вставить("ThickClientOrdinaryApplication", "Синтаксический контроль модулей в режиме эмуляции среды обычного приложения (толстый клиент), выполняемого в файловом режиме");
	Структура.Вставить("ThickClientServerOrdinaryApplication", "Синтаксический контроль модулей в режиме эмуляции среды обычного приложения (толстый клиент), выполняемого в клиент-серверном режиме");
	Структура.Вставить("DistributiveModules", "Поставка модулей без исходных текстов. В случае, если в настройках поставки конфигурации для некоторых модулей указана поставка без исходных текстов, проверяется возможность генерации образов этих модулей");
	Структура.Вставить("UnreferenceProcedures", "Поиск неиспользуемых процедур и функций. Поиск локальных (не экспортных) процедур и функций, на которые отсутствуют ссылки. В том числе осуществляется поиск неиспользуемых обработчиков событий");
	Структура.Вставить("HandlersExistence", "Проверка существования назначенных обработчиков. Проверка существования обработчиков событий интерфейсов, форм и элементов управления");
	Структура.Вставить("EmptyHandlers", "Поиск пустых обработчиков. Поиск назначенных обработчиков событий, в которых не выполняется никаких действий. Существование таких обработчиков может привести к снижению производительности системы");
	Структура.Вставить("ExtendedModulesCheck", "Проверка обращений к методам и свойствам объектов ""через точку"" (для ограниченного набора типов); проверка правильности строковых литералов - параметров некоторых функций, таких как ПолучитьФорму()");
	Структура.Вставить("CheckUseModality", "Режим поиска использования в модулях методов, связанных с модальностью. Опция используется только вместе с опцией --ExtendedModulesCheck");
	Структура.Вставить("CheckUseSynchronousCalls", "Режим поиска использования в модулях синхронных методов. Параметр используется только вместе с параметром --ExtendedModulesCheck");
	Структура.Вставить("UnsupportedFunctional", "Выполняется поиск функциональности, которая не может быть выполнена на мобильном приложении. Проверка в этом режиме показывает:
												|наличие в конфигурации метаданных, классы которых не реализованы на мобильной платформе;
												|наличие в конфигурации планов обмена, у которых установлено свойство ""Распределенная информационная база"";
												|использование типов, которые не реализованы на мобильной платформе:
												|	в свойствах ""Тип"" реквизитов метаданных, констант, параметров сеанса;
												|	в свойстве ""Тип параметра команды"" метаданного ""Команда"";
												|	в свойстве ""Тип"" реквизитов и колонок реквизита формы;
												|наличие форм с типом формы ""Обычная"";
												|наличие в форме элементов управления, которые не реализованы на мобильной платформе. Проверка не выполняется для форм, у которых свойство ""Назначение"" не предполагает использование на мобильном устройстве;
												|сложный состав рабочего стола (использование более чем одной формы).");		
	Структура.Вставить("AllExtensions", "Проверка всех расширений");
	// BSLLS:LineLength-on

	Возврат Структура;

КонецФункции

// Инициализирует параметры для выгрузки конфигурации 1С в cf-файл
//
// Возвращаемое значение:
//	Массив - массив строк всех параметров
//
Функция КонструкторВыгрузкиКонфигурации() Экспорт
	
	Результат = КонструкторОбщий();
	Возврат Результат;
	
КонецФункции

// Возвращает ключи для запуска проверки конфигурации по умолчанию.
//
// Возвращаемое значение:
//	Структура - Ключ - это ключ проверки, значение - это описание проверки
//
Функция ПараметрыПроверкиКонфигурацииПоУмолчанию() Экспорт

	Структура = Новый Структура();	
	Структура.Вставить("ThinClient", Истина);
	Структура.Вставить("WebClient", Истина);
	Структура.Вставить("Server", Истина);
	Структура.Вставить("ExternalConnection", Истина);
	Структура.Вставить("ExternalConnectionServer", Истина);
	Возврат Структура;

КонецФункции

// Инициализирует параметры для загрузки базы 1С из dt-файла
//
// Возвращаемое значение:
//	Массив - массив строк всех параметров
//
Функция КонструкторЗагрузкиИБ() Экспорт
	
	Результат = КонструкторОбщий();
	Результат.Добавить("file");
	Результат.Добавить("del");
	Возврат Результат;
	
КонецФункции

// Добавляет в команду приложения для FTP общие опции
//
// Параметры:
//  Команда    - КомандаПриложения      - объект  описание команды
//	МассивПараметров - Массив			- массив команд, которые надо зарегистрировать
//
// BSLLS:CognitiveComplexity-off
// BSLLS:CyclomaticComplexity-off
Процедура ОписаниеКоманды(Команда, Знач МассивПараметров) Экспорт
	
	СтрокаШаблона = "%1 %2";
	
	Если МассивПараметров.Найти("connection") <> Неопределено Тогда
		Текст = СтрШаблон(СтрокаШаблона,
				"Строка соединения с информационной базой 1С.",
				"Для файловой ""/FC:\Base1C"", а серверной ""/Sserver\base"" (обязательный)");
		Команда.Опция("connection с", "", Текст)
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("user") <> Неопределено Тогда
		Команда.Опция("user u n", "",
			"Имя пользователя (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("password") <> Неопределено Тогда
		Команда.Опция("password pwd p", "",
			"Пароль пользователя (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("server") <> Неопределено Тогда
		Команда.Опция("server", "",
			"Адрес кластера серверов 1С ([<протокол>://]<адрес>[:<порт>]) (обязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("ref") <> Неопределено Тогда
		Команда.Опция("ref", "",
			"Имя базы в кластере 1С (обязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("dbms") <> Неопределено Тогда
		Команда.Опция("dbms", "",
			"Тип сервера СУБД: MSSQLServer <по умолчанию>, PostgreSQL, IBMDB2, OracleDatabase (необязательный)")
			.ТСтрока();				
	КонецЕсли;
	
	Если МассивПараметров.Найти("dbserver") <> Неопределено Тогда
		Команда.Опция("dbserver", "",
			"Адрес сервера СУБД. Если не указано, то равен ""--server"" (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("dbuser") <> Неопределено Тогда
		Команда.Опция("dbuser", "",
			"Пользователь сервера СУБД (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("dbpassword") <> Неопределено Тогда
		Команда.Опция("dbpassword", "",
			"Пароль сервера СУБД (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("dbname") <> Неопределено Тогда
		Команда.Опция("dbname", "",
			"Имя базы на сервере СУБД. Если не указано, то равен ""--ref"" (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("sqloffs") <> Неопределено Тогда
		Команда.Опция("sqloffs", "",
			"Смещение дат на сервере MS SQL: 0; 2000 <по умолчанию> (необязательный)")
			.ТЧисло();
	КонецЕсли;
	
	Если МассивПараметров.Найти("createdb") <> Неопределено Тогда
		Команда.Опция("createdb", "",
			"Создавать базу данных в случае отсутствия (необязательный)")
			.ТБулево();
	КонецЕсли;
	
	Если МассивПараметров.Найти("allowschjob") <> Неопределено Тогда
		Команда.Опция("allowschjob", "",
			"Разрешить регламентные задания (необязательный)")
			.ТБулево();
	КонецЕсли;
	
	Если МассивПараметров.Найти("allowlicdstr") <> Неопределено Тогда
		Команда.Опция("allowlicdstr", "",
			"Разрешить выдачу лицензий сервером 1С (необязательный)")
			.ТБулево();
	КонецЕсли;
	
	Если МассивПараметров.Найти("cadmuser") <> Неопределено Тогда
		Команда.Опция("cadmuser", "",
			"Имя администратора кластера (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("cadmpassword") <> Неопределено Тогда
		Команда.Опция("cadmpassword", "",
			"Пароль администратора кластера (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("template") <> Неопределено Тогда
		Текст = СтрШаблон(СтрокаШаблона,
				"Путь к шаблону для создания информационной базы (*.cf; *.dt).",
				"Если шаблон не указан, то будет создана пустая ИБ (необязательный)");
		Команда.Опция("template t", "", Текст)
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("basename") <> Неопределено Тогда
		Команда.Опция("basename n", "",
			"Имя в списке баз пользователя. Если не задано, то ИБ в список не добавляется (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("v8version") <> Неопределено Тогда
		Команда.Опция("v8version v", "",
			"Версия платформы 1С (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("ordinaryapp") <> Неопределено Тогда
		Текст = СтрШаблон(СтрокаШаблона,
				"Запуск толстого клиента (1 = толстый, 0 = тонкий клиент, -1 = без указания клиента).",
				"По умолчанию используется значение 0 (тонкий клиент). (обязательный)");
		Команда.Опция("ordinaryapp o", "", Текст)
			.ТЧисло();
	КонецЕсли;
	
	Если МассивПараметров.Найти("uccode") <> Неопределено Тогда
		Команда.Опция("uccode uc", "",
			"Ключ разрешения запуска (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("language") <> Неопределено Тогда
		Команда.Опция("language", "",
			"Код языка запуска платформы (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("locale") <> Неопределено Тогда
		Команда.Опция("locale", "",
			"Код локализации сеанса платформы (необязательный)")
			.ТСтрока();
	КонецЕсли;
	
	Если МассивПараметров.Найти("nocacheuse") <> Неопределено Тогда
		Текст = СтрШаблон(СтрокаШаблона,
				"Признак - не использовать кэш платформы для ускорения операций с базой,",
				"а также не надо добавлять базу в список баз 1C пользователя. (необязательный)");
		Команда.Опция("nocacheuse", "", Текст)
			.ТБулево();
	КонецЕсли;
	
КонецПроцедуры

// Читает параметры из команды приложения
//
// Параметры:
//  Команда    - КомандаПриложения      - объект  описание команды
//	МассивПараметров - Массив			- массив команд, которые надо зарегистрировать
//
// Возвращаемое значение:
//	Структура - Считанные опции команды
//
Функция ПрочитатьПараметры(Знач Команда, Знач МассивПараметров = Неопределено) Экспорт
	
	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);
	
	ПараметрыКоманды = Новый Структура;
	Если МассивПараметров.Найти("connection") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("СтрокаПодключения", ЧтениеОпций.ЗначениеОпции("connection", Истина));
	КонецЕсли;
	Если МассивПараметров.Найти("user") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("Пользователь", ЧтениеОпций.ЗначениеОпции("user"));
	Иначе
		ПараметрыКоманды.Вставить("Пользователь", "");
	КонецЕсли;
	Если МассивПараметров.Найти("password") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("Пароль", ЧтениеОпций.ЗначениеОпции("password"));
	Иначе
		ПараметрыКоманды.Вставить("Пароль", "");
	КонецЕсли;
	Если МассивПараметров.Найти("v8version") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("ВерсияПлатформы", ЧтениеОпций.ЗначениеОпции("v8version"));
	КонецЕсли;
	ПараметрыКоманды.Вставить("РежимЗапуска", 0);
	Если МассивПараметров.Найти("ordinaryapp") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("РежимЗапуска", ЧтениеОпций.ЗначениеОпции("ordinaryapp"));
	КонецЕсли;	
	Если МассивПараметров.Найти("language") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("КодЯзыка", ЧтениеОпций.ЗначениеОпции("language"));
	КонецЕсли;
	Если МассивПараметров.Найти("locale") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("КодЯзыкаСеанса", ЧтениеОпций.ЗначениеОпции("locale"));
	КонецЕсли;
	Если МассивПараметров.Найти("uccode") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("КлючРазрешенияЗапуска", ЧтениеОпций.ЗначениеОпции("uccode"));
	КонецЕсли;
	Если МассивПараметров.Найти("nocacheuse") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("НеИспользоватьКэш", ЧтениеОпций.ЗначениеОпции("nocacheuse"));
	КонецЕсли;
	Если МассивПараметров.Найти("server") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("Сервер1С", ЧтениеОпций.ЗначениеОпции("server", Истина));
	КонецЕсли;
	Если МассивПараметров.Найти("ref") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("ИмяИБ", ЧтениеОпций.ЗначениеОпции("ref", Истина));
	КонецЕсли;
	Если МассивПараметров.Найти("dbms") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("ТипСУБД", ЧтениеОпций.ЗначениеОпции("dbms"));
		Если НЕ ЗначениеЗаполнено(ПараметрыКоманды.ТипСУБД) Тогда
			ПараметрыКоманды.ТипСУБД = Перечисления.ТипыСУБД.MSSQLServer;
		КонецЕсли;
	КонецЕсли;
	Если МассивПараметров.Найти("dbserver") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("СерверСУБД", ЧтениеОпций.ЗначениеОпции("dbserver"));
	КонецЕсли;
	Если МассивПараметров.Найти("dbuser") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("ПользовательСУБД", ЧтениеОпций.ЗначениеОпции("dbuser"));
	КонецЕсли;
	Если МассивПараметров.Найти("dbpassword") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("ПарольСУБД", ЧтениеОпций.ЗначениеОпции("dbpassword"));
	КонецЕсли;
	Если МассивПараметров.Найти("dbname") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("ИмяБД", ЧтениеОпций.ЗначениеОпции("dbname"));
	КонецЕсли;
	Если МассивПараметров.Найти("sqloffs") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("СмещениеДат", ЧтениеОпций.ЗначениеОпции("sqloffs"));
		Если НЕ ЗначениеЗаполнено(ПараметрыКоманды.СмещениеДат) Тогда
			ПараметрыКоманды.СмещениеДат = 2000;
		КонецЕсли;
	КонецЕсли;
	Если МассивПараметров.Найти("createdb") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("СоздаватьБД", ЧтениеОпций.ЗначениеОпции("createdb"));
	КонецЕсли;
	Если МассивПараметров.Найти("allowschjob") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("РазрешитьРегЗадания", ЧтениеОпций.ЗначениеОпции("allowschjob"));
	КонецЕсли;
	Если МассивПараметров.Найти("allowlicdstr") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("РазрешитьВыдачуЛицензий", ЧтениеОпций.ЗначениеОпции("allowlicdstr"));
	КонецЕсли;
	Если МассивПараметров.Найти("cadmuser") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("АдминистраторКластера", ЧтениеОпций.ЗначениеОпции("cadmuser"));
	КонецЕсли;
	Если МассивПараметров.Найти("cadmpassword") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("ПарольКластера", ЧтениеОпций.ЗначениеОпции("cadmpassword"));
	КонецЕсли;
	Если МассивПараметров.Найти("template") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("ПутьКШаблону", ЧтениеОпций.ЗначениеОпции("template"));
	КонецЕсли;
	Если МассивПараметров.Найти("basename") <> Неопределено Тогда
		ПараметрыКоманды.Вставить("ИмяБазыВСписке", ЧтениеОпций.ЗначениеОпции("basename"));
	КонецЕсли;
	
	Возврат ПараметрыКоманды;
	
КонецФункции
// BSLLS:CognitiveComplexity-on
// BSLLS:CyclomaticComplexity-on

// Выполняет очистку локального кэша информационной базы 1С
//
// Параметры:
//   СтрокаПодключения           - Строка    - строка подключения к базе 1С
//
Процедура ОчиститьЛокальныйКэшИнформационнойБазы(Знач СтрокаПодключения) Экспорт

	Лог = ПараметрыСистемы.Лог();
	ДлинаТипаПодключения = 2;
	ТипПодключения = Лев(ВРег(СтрокаПодключения), ДлинаТипаПодключения);
	АдресПодключения = СокрЛП(Сред(СтрокаПодключения, ДлинаТипаПодключения + 1));

	Если ТипПодключения = "/F" Тогда
		ПутьКБазе = АдресПодключения;
	ИначеЕсли ТипПодключения = "/S" Тогда
		ПутьКБазе = АдресПодключения;
		ПутьКБазе = СтрЗаменить(ПутьКБазе, "\", ":");
	Иначе
		ПутьКБазе = СтрокаПодключения;
	КонецЕсли;

	ПарсерСпискаБаз = Новый ПарсерСпискаБаз();
	ПарсерСпискаБаз.УстановитьФайл();

	Результат = ПарсерСпискаБаз.НайтиПоПути(ПутьКБазе);
	Если Результат = Неопределено Тогда
		Лог.Предупреждение("Ошибка очистки кэша, база %1 не найдена в списке баз.", ПутьКБазе);
	Иначе
		Чистильщик = Новый ОчисткаКеша();
		Чистильщик.УстановитьПарсер(ПарсерСпискаБаз);
		Чистильщик.ОчиститьКеш(Результат);

		Лог.Информация("Выполнена очистка кэша базы ""%1"".", СтрокаПодключения);
	КонецЕсли;

КонецПроцедуры // ОчиститьЛокальныйКэшИнформационнойБазы()

// Выполняет очистку всех локальных кэшей информационных баз 1С
//
Процедура ОчиститьВсеЛокальныеКэшиИнформационныхБаз() Экспорт

	Лог = ПараметрыСистемы.Лог();
	КаталогКэша = ПолучитьКаталогКэша();

	КаталогиКэша = НайтиФайлы(КаталогКэша, "*");

	РВ = Новый РегулярноеВыражение("(?i)[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}");

	Для Каждого ТекКаталог Из КаталогиКэша Цикл

		Если НЕ ТекКаталог.ЭтоКаталог() Тогда
			Продолжить;
		КонецЕсли;
	
		Если НЕ РВ.Совпадает(ТекКаталог.Имя) Тогда
			Продолжить;
		КонецЕсли;

		Попытка
			УдалитьФайлы(ТекКаталог.ПолноеИмя);
			Лог.Информация("Удален каталог кэша ""%1"".", ТекКаталог.ПолноеИмя);
		Исключение
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			Лог.Предупреждение("Ошибка удаления каталога кэша ""%1"": %2%3",
			                   ТекКаталог.ПолноеИмя,
			                   Символы.ПС,
			                   ТекстОшибки);
		КонецПопытки;
		
	КонецЦикла;

КонецПроцедуры // ОчиститьВсеЛокальныеКэшиИнформационныхБаз()

// Получить каталог кеша информационных баз 1С
// с учетом операционной системы
//
// Возвращаемое значение:
//   Строка    - путь к каталогу кэша ИБ 1С
//
Функция ПолучитьКаталогКэша() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоWindows = Найти(ВРег(СистемнаяИнформация.ВерсияОС), "WINDOWS") > 0;
	Если ЭтоWindows Тогда
		ЗначениеПеременной = ПолучитьПеременнуюСреды("USERPROFILE");
		КаталогКеша = ОбъединитьПути(ЗначениеПеременной, "appdata\local\1c\1cv8");
	Иначе
		ЗначениеПеременной = ПолучитьПеременнуюСреды("HOME");
		КаталогКеша = ОбъединитьПути(ЗначениеПеременной, "./.1cv82/1C/1Cv82/");
	КонецЕсли;

	Возврат КаталогКеша;

КонецФункции // ПолучитьКаталогКэша()

#КонецОбласти
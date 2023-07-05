﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
			
	// Добавление дополнительных опций
	ПараметрыОпций = Работа1С.КонструкторОбщий();
	Работа1С.ОписаниеКоманды(Команда, ПараметрыОпций);

	Команда.Опция("path to p", "",
		"Путь к каталогу, куда надо выгрузить конфигурацию в формат XML 1С (обязательный)")
		.ТСтрока();

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	ПараметрыКоманды = ПолучитьСтруктуруПараметров(Команда);
	МенеджерКонфигуратора = Новый МенеджерКонфигуратора();
	МенеджерКонфигуратора.Инициализация(ПараметрыКоманды);
	МенеджерКонфигуратора.ВыгрузитьКонфигурациюВФайлыXML(ПараметрыКоманды.Каталог);
	МенеджерКонфигуратора.Деструктор();
	
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)
	
	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);
	
	ПараметрыОпций = Работа1С.КонструкторПроверкиКонфигурации();	
	ПараметрыКоманды = Работа1С.ПрочитатьПараметры(Команда, ПараметрыОпций);
	ПараметрыКоманды.Вставить("Каталог", ЧтениеОпций.ЗначениеОпции("path", Истина));

	Возврат ПараметрыКоманды;
	
КонецФункции // ПолучитьСтруктуруПараметров()

#КонецОбласти // СлужебныеПроцедурыИФункции
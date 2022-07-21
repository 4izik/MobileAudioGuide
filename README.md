# Приложение Mobile audio guide
Приложение-аудиогид с оффлайн картой.

<img width="300" src="https://user-images.githubusercontent.com/79922250/177061759-166cc809-cd48-4e6d-9c4e-ceba3a0e0706.png"> <img width="300" src="https://user-images.githubusercontent.com/79922250/177061769-2e99515f-04ea-4e79-8c96-2a04f88274d6.png"> <img width="300" src="https://user-images.githubusercontent.com/79922250/177061766-0f591d9a-4e54-464f-a9cf-b4b5e99ed2c5.png"> <img width="300" src="https://user-images.githubusercontent.com/79922250/177061765-1ee8fdce-3cb9-4be0-a967-c42c1fe8b776.png"> <img width="300" src="https://user-images.githubusercontent.com/79922250/177061764-518f3ee2-ec32-4abe-992e-e1500859344d.png">

## Как изменять данные в приложении

Самая главная часть приложения, отвечающая за именование файлов и правильное их отображение, а также за верное отображаение точек на карте - файл **Excursions.plist**. Он находится в проекте по пути **MobileAudioGuide\Resources\Excursions.plist**

![Excursions.plist screenshot](https://user-images.githubusercontent.com/79922250/177060707-826108f7-7a1b-48bc-ad04-c23d0deeb09d.png)

## Структура файла **Excursions.plist**:

В корне лежат объекты экскурсий (которые состоят из какого-то количества аудиотуров). Список экскурсий в приложении отображается на главном экране. **Item0** соответствует первая экскрусия, **Item1** - вторая и т.д. Если нужно добавить еще одну экскурсию, можно скопировать-вставить существуюущую и внести правки в копию.

В каждой из экскурсий обязательны следующие поля:

<img width="1300" src="https://user-images.githubusercontent.com/79922250/178507485-4b4bc53c-d389-45a1-881c-f5bdfe7885b6.png">

- **excursionTitle** - полный заголовок экскурсии. Отображается при переходе с главного экрана на экран выбранной экскурсии, а также на экране покупки экскурсии;
- **shortTitle** - короткий заголовок экскурсии. Используется на некоторых экранах, таких как экран карты и экран подробной информации о выбранной точке (туре);
- **excursionDuration** - продолжительность экскурсии. Пишется не только цифра, но и в чем измеряется. Например: "1 day";
- **routeDistance** - длина маршрута экскурсии. Пишется не только цифра, но и в чем измеряется. Например: "6 km";
- **transportType** - способ передвижения по маршруту. Например: "on foot";
- **filenamePrefix** - **очень важный параметр, от которого будет зависеть корректное отображение всех данных (фото, аудио, тексты) в приложении!** Это базовый префикс имени файлов (его начальная часть) для данной экскурсии. Например, если префикс в этом поле задать "CityOverNight", то:
	+ фотографии для этой экскурсии должны будут называться "**CityOverNight0.jpg**", "**CityOverNight1.jpg**" и т.д.,
	+ тексты для этой экскурсии должны будут называться "**CityOverNight0.txt**", "**CityOverNight1.txt**" и т.д.,
	+ аудиозаписи для этой экскурсии должны будут называться "**CityOverNight0.mp3**", "**CityOverNight1.mp3**" и т.д.
	
	Учитывайте, что написание чувствительно к регистру, повторение должно быть 100%.

- **mapScreenCoordinates** - если развернуть этот параметр, в нем есть два поля, отвечающих за географические координаты точки, которая будет изначально отображаться в центре экрана карты при переходе на него:
	+ **latitude** - географическая широта точки;
	+ **longitude** - географическая долгота точки.

- **tours** - массив туров (точек на маршруте), из которых состоит экскурсия. Каждый тур содержит три поля:
	+ **tourTitle** - заголовок для данного тура;
	+ **imageUrl** - ссылка на исходную фотографию для данного тура (для Creative Commons License);
	+ **latitude** - географическая широта точки;
	+ **longitude** - географическая долгота точки.

> ### Важно!
> Имена всех полей в файле **Excursions.plist** должны полностю повторять указанные выше - они чувствительны к регистру.

## Хранение и правила именования файлов ресурсов (фото, тексты, аудио)
Все основные ресурсы, необходимые для донесения информации об экскурсии до пользователя, делятся на три типа:

- **фотографии** (должны иметь расширение .jpg);
- **аудиозаписи** для аудиогида (должны иметь расширение .mp3);
- **тексты** для описания туров и экскурсии в целом (должны иметь расширение .txt).

Они расположены в следующих местах внутри проекта:

- **фотографии**: по пути **MobileAudioGuide\Assets.xcassets**. Внутри Assets можно создать подпапки для лучшей организации файлов. Имена папок ни на что не влияют (в отличии от имен самих фотографий);

<img width="800" src="https://user-images.githubusercontent.com/79922250/177060972-a51acd57-de95-4e93-be45-02b5b1a585c3.png">

- **аудиозаписи**: по пути **MobileAudioGuide\Resources\ExcursionsInfoData\Название\_папки_экскурсии\Audio**;
- **тексты**: по пути **MobileAudioGuide\Resources\ExcursionsInfoData\Название\_папки_экскурсии\Texts**.
<img width="333" src="https://user-images.githubusercontent.com/79922250/177061068-1003e7bb-e169-4025-acd8-3dc6ba3820ab.png">

Файлы внутри этих папок должны называться в строгом соответствии со следующими правилами, чтобы отображение всех ресурсов в приложении было корректным:

1. Имя файла должно состоять только из **префикса** (значение поля **filenamePrefix** из **Excursions.plist**) и **цифры**, означающей порядковый номер тура этого фото/аудио/текста. Например: если в поле filenamePrefix из Excursions.plist указано "BestExcursion", то для первой точки маршрута будут соответствовать файлы BestExcursion1.jpg, BestExcursion1.mp3 и BestExcursion1.txt.
2. Цифра 0 (ноль), стоящая после filenamePrefix, применяется для экрана общего описания экскурсии и означает аудио/фото/текст для экрана описания экскурсии, на который пользователь переходит с главного экрана приложения;
3. Нельзя добавлять дополнительные символы в цифры, например, файл с именем BestExcursion001.jpg будет проигнорирован, так как в нем указана цифра "001" вместо "1".

## Другие важные ресурсы

Кроме Excursions.plist и фото/аудио/текстов экскурсий в проекте есть еще несколько важных ресурсов:

- Файл с текстом описания покупки того или иного тура. Имеет формат "aboutPurchase0.txt" где 0 - индекс экскурсии. Для первой экскурсии индекс равен 0, для второй - 1 и т.д. Файл расположен по пути **MobileAudioGuide\Resources\ExcursionsInfoData\Название\_папки_экскурсии**:
<img width="333" src="https://user-images.githubusercontent.com/79922250/177061232-12b7b073-7034-4c91-affa-7ab8c069faef.png">

- Файл формата GeoJSON, необходимый для отрисовки линии маршрута экскурсии. Имя файла должно полностью повторять значение поля **filenamePrefix** из **Excursions.plist** (без каких-либо дополнительных символов) и иметь расширение **.geojson**. Например: "IstambulInOneDay.geojson". Сформировать такой файл можно на сайте <https://classic-maps.openrouteservice.org/>, проложив маршрут, нажав на кнопку "Экспорт маршрута" и выбрав формат файла GeoJSON. Файл в проекте располагается по пути **MobileAudioGuide\Resources\ExcursionsInfoData\Название\_папки_экскурсии\GeoJSON**:
<img width="333" src="https://user-images.githubusercontent.com/79922250/177061365-dd0c232c-c729-4c55-891b-4cb3e58b3f0b.png">

- Файл с информацией об авторе экскурсий. Должен называться "**infoAboutAuthor.txt**". Файл в проекте располагается по пути **MobileAudioGuide\Resources**:
<img width="800" src="https://user-images.githubusercontent.com/79922250/177061437-498d9995-fc64-4946-b6a4-c214d5a2312d.png">

## Offline карта

Приложению требуется один раз скачать карту при первом входе в приложение, после этого Интернет не будет нужен для ее отображения (до момента удаления приложения с утройства).

Чтобы изменить координаты скачиваемой карты в OfflineManager следует изменить переменную **istanbulCoord** в Utils/MapTilesLoader.swift.

<img width="800" src="https://user-images.githubusercontent.com/79922250/180160022-46b54c4a-9115-40d6-8986-bf410dc03037.png">


##  Главный экран Main
Фоновую картинку закинуть в Assets.<br>
Фоновая картинка экрана должна называться backGroundImage

Названия туров находятся в MainViewController массив namesTours.

Изменение ссылки на отели в функции openHotelsURL (MainViewController).<br>
Изменение ссылки на туры в функции openTicketsURL (MainViewController).

##  Экран GuideHeaderView

Ограничение заголовка экскурсии: 2 строки и отступы слева и справа по 40 point

## Правка цветовой схемы приложения

Все основные цвета приложения можно задавать в файле Colors.swift:

<img width="800" src="https://user-images.githubusercontent.com/79922250/178516208-adff6ae2-e9e9-44d0-814d-759d8c994537.png">

Самым главным является **appAccentColor** - он отвечает за доминирующий цвет всего приложения (по умолчанию сине-голубой).

Поменять цвет можно как через предустановленные системные цвета, например, UIColor.systemBlue (системный голубой цвет), так и выбрав любой цвет по его hex значению через инициализатор UIColor(rgb:). Hex значение для определенного цвета можно получить либо в вашем графическом редакторе с помощью пипетки, либо на сайте https://csscolor.ru/hex/:

<img width="600" src="https://user-images.githubusercontent.com/79922250/178517899-50ec4df8-57bd-40a3-8230-0e62bf5d73b9.png">

Например, для коричневого цвета с hex значением **853720** переменной appAccentColor нужно задать сначение UIColor(rgb: 0x**853720**).

```swift
/// Главный (акцентный) цвет приложения (по умолчанию сине-голубой)
    static let appAccentColor = UIColor(rgb: 0x853720)
``` 

Тогда интерфейс приложения будет выглядеть так:

<img width="300" src="https://user-images.githubusercontent.com/79922250/178519661-69149972-9b83-4642-9b58-f0c2bc8b6105.png">

Правка остальных цветов в файле Colors.swift осуществляется аналогичным образом.

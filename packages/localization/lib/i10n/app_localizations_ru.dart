// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Тентура';

  @override
  String get labelTitle => 'Заголовок';

  @override
  String get labelDescription => 'Описание';

  @override
  String get labelMe => 'Я';

  @override
  String get labelOr => 'или';

  @override
  String get labelConfirmation => 'Вы уверены?';

  @override
  String get labelNothingHere => 'Здесь пока ничего нет';

  @override
  String get labelSettings => 'Настройки';

  @override
  String get buttonCancel => 'Отмена';

  @override
  String get buttonDelete => 'Удалить';

  @override
  String get buttonRemove => 'Убрать';

  @override
  String get buttonCreate => 'Создать';

  @override
  String get buttonComplaint => 'Жалоба';

  @override
  String get buttonYes => 'Да';

  @override
  String get buttonOk => 'Ок';

  @override
  String get buttonSave => 'Сохранить';

  @override
  String get buttonClose => 'Закрыть';

  @override
  String get buttonSearch => 'Поиск';

  @override
  String get buttonScanQR => 'Сканировать QR';

  @override
  String get createNewAccount => 'Создать аккаунт';

  @override
  String get pleaseFillTitle => 'Пожалуйста, укажите заголовок';

  @override
  String get confirmAccountRemoval => 'Вы уверены, что хотите удалить этот аккаунт?';

  @override
  String get chooseAccount => 'Выберите аккаунт';

  @override
  String get alreadyHaveAccount => 'У вас уже есть аккаунт?\nПолучите доступ, отсканировав QR-код на другом устройстве\nили используя сохранённую seed-фразу.';

  @override
  String get recoverFromQR => 'Восстановить из QR';

  @override
  String get recoverFromClipboard => 'Восстановить из буфера';

  @override
  String get shareAccount => 'Поделиться аккаунтом';

  @override
  String get showSeed => 'Показать Seed';

  @override
  String get removeFromList => 'Убрать из списка';

  @override
  String get confirmBeaconRemoval => 'Вы уверены, что хотите удалить этот маяк?';

  @override
  String get beaconsTitle => 'Маяки';

  @override
  String get noBeaconsMessage => 'Мяков пока нет';

  @override
  String get disableBeacon => 'Отключить маяк';

  @override
  String get enableBeacon => 'Включить маяк';

  @override
  String get deleteBeacon => 'Удалить маяк';

  @override
  String get showOnMap => 'Показать на карте';

  @override
  String get confirmBeaconPublishing => 'Вы уверены, что хотите опубликовать этот маяк?';

  @override
  String get confirmBeaconPublishingHint => 'После публикации маяка изменения будут невозможны. Вы уверены, что хотите опубликовать этот маяк?';

  @override
  String get createNewBeacon => 'Создать маяк';

  @override
  String get setDisplayPeriod => 'Выберите период отображения';

  @override
  String get beaconTitleRequired => 'Название маяка (обязательно)';

  @override
  String get buttonPublish => 'Опубликовать';

  @override
  String get addLocation => 'Добавить место';

  @override
  String get attachImage => 'Прикрепить изображение';

  @override
  String get labelComments => 'Комментарии';

  @override
  String get showAllComments => 'Показать все комментарии';

  @override
  String get writeComment => 'Написать комментарий';

  @override
  String get chatLabelToday => 'Сегодня';

  @override
  String get submitComplaint => 'Отправить жалобу';

  @override
  String get violatesCSAE => 'Нарушает политику CSAE';

  @override
  String get violatesPlatformRules => 'Нарушает правила платформы';

  @override
  String get labelComplaintType => 'Тип жалобы';

  @override
  String get detailsRequired => 'Подробности*';

  @override
  String get provideDetails => 'Пожалуйста, укажите подробности';

  @override
  String get feedbackEmail => 'Email для обратной связи (необязательно)';

  @override
  String get emailValidationError => 'Введите корректный email';

  @override
  String get buttonSubmitComplaint => 'ОТПРАВИТЬ ЖАЛОБУ';

  @override
  String get writeCodeHere => 'Если у вас есть код, введите его здесь:';

  @override
  String get codeLengthError => 'Неверная длина кода!';

  @override
  String get codePrefixError => 'Неверный префикс кода!';

  @override
  String get addNewTopic => 'Добавить новую тему';

  @override
  String topicRemovalMessage(String contextName) {
    return 'Тема $contextName будет удалена из вашего списка!';
  }

  @override
  String get allTopics => 'Все темы';

  @override
  String confirmFriendRemoval(String profileTitle) {
    return 'Вы уверены, что хотите удалить $profileTitle из списка друзей?';
  }

  @override
  String get tapToChooseLocation => 'Нажмите, чтобы выбрать место';

  @override
  String get goToEgo => 'Перейти к Эго';

  @override
  String get showNegative => 'Показать негативные';

  @override
  String get hideNegative => 'Скрыть негативные';

  @override
  String get graphView => 'Просмотр графа';

  @override
  String get myField => 'Моё поле';

  @override
  String get favorites => 'Избранное';

  @override
  String get connect => 'Связаться';

  @override
  String get friends => 'Друзья';

  @override
  String get profile => 'Профиль';

  @override
  String get introTitle => 'Стройте свою личную сеть прозрачно!';

  @override
  String get introText => 'Каждая публикация показывает, что именно связывает вас с окружающими. Проверьте эти связи и держите ваши отношения под контролем!';

  @override
  String get buttonStart => 'Начать';

  @override
  String get confirmOpinionRemoval => 'Вы уверены, что хотите удалить это мнение?';

  @override
  String get noOpinions => 'Мнений пока нет';

  @override
  String get deleteOpinion => 'Удалить моё мнение';

  @override
  String get confirmProfileRemoval => 'Вы уверены, что хотите удалить ваш профиль?';

  @override
  String get profileRemovalHint => 'Все ваши маяки и личные данные будут полностью удалены.';

  @override
  String get showConnections => 'Показать связи';

  @override
  String get showBeacons => 'Показать маяки';

  @override
  String get newBeacon => 'Новый маяк';

  @override
  String get communityFeedback => 'Отзывы сообщества';

  @override
  String get addToMyField => 'Добавить в моё поле';

  @override
  String get removeFromMyField => 'Убрать из моего поля';

  @override
  String get onlyOneOpinion => 'Вы можете оставить только одно мнение';

  @override
  String get writeOpinion => 'Написать мнение';

  @override
  String get positiveOrNegativeOpinion => 'Это мнение положительное или отрицательное?';

  @override
  String get positiveOpinion => 'Положительное';

  @override
  String get negativeOpinion => 'Отрицательное';

  @override
  String get rating => 'Рейтинг';

  @override
  String get searchBy => 'Поиск по';

  @override
  String get showIntroAgain => 'Показать интро снова';

  @override
  String get logout => 'Выйти';

  @override
  String get light => 'Светлая';

  @override
  String get system => 'Системная';

  @override
  String get dark => 'Тёмная';

  @override
  String get notImplementedYet => 'Ещё не реализовано';

  @override
  String get markAllAsRead => 'Отметить всё прочитанным';

  @override
  String get scanQrCode => 'Отсканируйте QR-код';

  @override
  String get noName => 'Без имени';

  @override
  String get copyToClipboard => 'Скопировать в буфер';

  @override
  String get seedCopied => 'Seed-фраза скопирована!';

  @override
  String get shareLink => 'Поделиться ссылкой';
}

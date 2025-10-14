import 'package:jaspr/server.dart';

const kThemeLightPurple = Color('#ECF0FC');
const kThemeLightFontMain = Color('#1D1B1E');
const kThemeLightBoxShadow = Color('#D4DEF7');
const kThemeLightCommentbg = Color('#F0F2FB');

const kThemeDarkPurple = Color('#403965');
const kThemeDarkCardBg = Color('#30344D');
const kThemeDarkFontMain = Color('#F6FDFE');
const kThemeDarkBoxShadow = Color('#1F1D37');
const kThemeDarkCommentBg = Color('#3c4055');

const kEdgeInsetsXS = Unit.pixels(4);
const kEdgeInsetsS = Unit.pixels(8);
const kEdgeInsetsSXS = Unit.pixels(12);
const kEdgeInsetsM = Unit.pixels(16);
const kEdgeInsetsMS = Unit.pixels(24);

final defaultStyles = [
  css(':root').styles(
    raw: {
      '--background-color-purple': kThemeLightPurple.value,
      '--font-main': kThemeLightFontMain.value,
      '--shadow-color': kThemeLightBoxShadow.value,
      '--card-bg': kThemeDarkFontMain.value,
      '--avatar-name': kThemeDarkPurple.value,
      '--comment-bg': kThemeLightCommentbg.value,
    },
  ),

  css.media(const MediaQuery.all(prefersColorScheme: ColorScheme.dark), [
    css(':root').styles(
      raw: {
        '--background-color-purple': kThemeDarkPurple.value,
        '--font-main': kThemeDarkFontMain.value,
        '--shadow-color': kThemeDarkBoxShadow.value,
        '--card-bg': kThemeDarkCardBg.value,
        '--avatar-name': kThemeLightPurple.value,
        '--comment-bg': kThemeDarkCommentBg.value,
      },
    ),
  ]),

  css('html, body').styles(
    width: 100.percent,
    minHeight: 100.vh,
    padding: Spacing.zero,
    margin: Spacing.zero,
    color: const Color.variable('--font-main'),
    fontFamily: FontFamilies.sansSerif,
  ),

  css('p').styles(margin: Spacing.unset),

  css('h1').styles(
    margin: Spacing.unset,
    fontSize: 20.px,
    fontWeight: FontWeight.normal,
  ),

  css('.secondary-text').styles(
    color: const Color('#78839C'),
    fontSize: 12.px,
  ),

  css('.card', [
    css('&').styles(
      display: Display.flex,
      minHeight: const Unit.vh(100),
      flexDirection: FlexDirection.column,
      flex: const Flex(grow: 1),
      backgroundColor: const Color.variable('--card-bg'),
    ),
    css('&-container').styles(
      padding: const Spacing.only(
        left: kEdgeInsetsM,
        right: kEdgeInsetsM,
        bottom: kEdgeInsetsMS,
        top: kEdgeInsetsMS,
      ),
    ),
  ]),

  css('.card-avatar', [
    css('&__image')
        .styles(
          margin: const Spacing.only(left: Unit.pixels(-2)),
          border: const Border(
            color: Color.variable('--card-bg'),
            width: Unit.pixels(4),
          ),
          radius: const BorderRadius.circular(Unit.percent(50)),
        )
        .styles(raw: {'object-fit': 'cover'}),
    css('&__text').styles(
      color: const Color.variable('--avatar-name'),
    ),
  ]),

  // large screens
  css.media(MediaQuery.screen(minWidth: 480.px), [
    css('body').styles(
      display: Display.flex,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      backgroundColor: const Color.variable('--background-color-purple'),
    ),

    css('.card').styles(
      minHeight: Unit.auto,
      maxWidth: const Unit.pixels(360),
      radius: const BorderRadius.circular(Unit.pixels(8)),
      shadow: const BoxShadow(
        offsetX: Unit.zero,
        offsetY: Unit.pixels(8),
        blur: Unit.pixels(16),
        spread: Unit.pixels(6),
        color: Color.variable('--shadow-color'),
      ),
    ),
  ]),
];

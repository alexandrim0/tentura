import 'package:jaspr/jaspr.dart';

const kThemeLightPurple = Color.hex('#ECF0FC');
const kThemeLightFontMain = Color.hex('#1D1B1E');
const kThemeLightBoxShadow = Color.hex('#D4DEF7');
const kThemeLightCommentbg = Color.hex('#F0F2FB');

const kThemeDarkPurple = Color.hex('#403965');
const kThemeDarkCardBg = Color.hex('#30344D');
const kThemeDarkFontMain = Color.hex('#F6FDFE');
const kThemeDarkBoxShadow = Color.hex('#1F1D37');
const kThemeDarkCommentBg = Color.hex('#3c4055');

List<StyleRule> get defaultStyles => [
      css(':root').raw({
        '--background-color-purple': kThemeLightPurple.value,
        '--font-main': kThemeLightFontMain.value,
        '--shadow-color': kThemeLightBoxShadow.value,
        '--card-bg': kThemeDarkFontMain.value,
        '--avatar-name': kThemeDarkPurple.value,
        '--comment-bg': kThemeLightCommentbg.value,
      }),
      css.media(
        const MediaQuery.all(prefersColorScheme: ColorScheme.dark),
        [
          css(':root').raw({
            '--background-color-purple': kThemeDarkPurple.value,
            '--font-main': kThemeDarkFontMain.value,
            '--shadow-color': kThemeDarkBoxShadow.value,
            '--card-bg': kThemeDarkCardBg.value,
            '--avatar-name': kThemeLightPurple.value,
            '--comment-bg': kThemeDarkCommentBg.value,
          }),
        ],
      ),
      css('html, body')
          .box(
              width: 100.percent,
              minHeight: 100.vh,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero)
          .text(
              fontFamily: FontFamilies.sansSerif,
              color: const Color.variable('--font-main')),
      css('p').box(margin: EdgeInsets.unset),
      css('h1')
          .box(margin: EdgeInsets.unset)
          .text(fontSize: 20.px, fontWeight: FontWeight.normal),
      css('.secondary-text')
          .text(fontSize: 12.px, color: const Color.hex('#78839C')),
      css('.card', [
        css('&')
            .flexbox(direction: FlexDirection.column)
            .raw({'flex-grow': '1'})
            .box(minHeight: const Unit.vh(100))
            .background(color: const Color.variable('--card-bg')),
        css('&-container').box(
          padding: const EdgeInsets.only(
            left: Unit.pixels(16),
            right: Unit.pixels(16),
            bottom: Unit.pixels(24),
            top: Unit.pixels(24),
          ),
        ),
      ]),
      css('.card-avatar', [
        css('&__image')
            .box(
                margin: const EdgeInsets.only(left: Unit.pixels(-2)),
                radius: const BorderRadius.circular(Unit.percent(50)),
                border: const Border.all(
                  BorderSide.solid(
                      color: Color.variable('--card-bg'),
                      width: Unit.pixels(4)),
                ))
            .raw({'object-fit': 'cover'}),
        css('&__text').text(color: const Color.variable('--avatar-name')),
      ]),
      // large screens
      css.media(
        MediaQuery.screen(minWidth: 480.px),
        [
          css('body')
              .flexbox(
                alignItems: AlignItems.center,
                justifyContent: JustifyContent.center,
              )
              .background(
                  color: const Color.variable('--background-color-purple')),
          css('.card').box(
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
        ],
      ),
    ];

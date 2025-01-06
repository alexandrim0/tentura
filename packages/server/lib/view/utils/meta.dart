import 'package:tentura_server/consts.dart';

const metaCommon = {
  'iewport': 'width=device-width, initial-scale=1, '
      'minimum-scale=1,maximum-scale=1 user-scalable=no',
  'referrer': 'origin-when-cross-origin',
  'robots': 'noindex',
  'og:type': 'website',
  'og:site_name': 'Tentura',
};

Map<String, String> buildMetaOpenGraph({
  required String id,
  required String title,
  required String description,
  required String imagePath,
  String? serverName,
}) {
  serverName ??= kServerName;
  return {
    'og:title': title,
    'og:description': description,
    'og:url': 'https://$serverName/shared/view?id=$id',
    'og:image': 'https://$serverName/$imagePath',
  };
}

import 'package:tentura/ui/routes.dart';
import 'package:tentura/ui/utils/ferry_utils.dart';

import '../../data/gql/_g/beacon_delete_by_id.req.gql.dart';
import '../../domain/entity/beacon.dart';

class BeaconDeleteDialog extends StatelessWidget {
  final Beacon beacon;

  const BeaconDeleteDialog({
    required this.beacon,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Are you sure you want to delete this beacon?'),
        actions: [
          TextButton(
            onPressed: () async {
              final response = await doRequest(
                context: context,
                request: GBeaconDeleteByIdReq((b) => b.vars..id = beacon.id),
              );
              if (context.mounted) {
                if (response.hasErrors) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Error has occurred'),
                  ));
                }
                context.pop();
              }
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: context.pop,
            child: const Text('Cancel'),
          ),
        ],
      );
}

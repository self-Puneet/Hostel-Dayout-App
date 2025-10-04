import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:timelines_plus/timelines_plus.dart';

enum CheckpointState { completed, notCompleted, rejected }

class Checkpoint {
  final String title;
  final CheckpointState state;
  Checkpoint(this.title, this.state);
}

class HorizontalCheckpointTimeline extends StatelessWidget {
  final List<Checkpoint> checkpoints;

  const HorizontalCheckpointTimeline({Key? key, required this.checkpoints})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;
        final itemWidth = fullWidth / checkpoints.length;

        return FixedTimeline.tileBuilder(
          direction: Axis.horizontal,
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: checkpoints.length,
            // Build each indicator (checkpoint)
            indicatorBuilder: (_, index) {
              final checkpoint = checkpoints[index];
              switch (checkpoint.state) {
                case CheckpointState.completed:
                  return DotIndicator(
                    size: 26,
                    color: Color.fromRGBO(92, 230, 92, 1),
                    child: Icon(Icons.check, color: Colors.white, size: 22),
                  );
                case CheckpointState.notCompleted:
                  return DotIndicator(
                    size: 26,
                    color: Color.fromRGBO(178, 178, 178, 1),
                  );
                case CheckpointState.rejected:
                  return DotIndicator(
                    size: 26,
                    color: Colors.red,
                    child: Icon(Icons.close, color: Colors.white, size: 22),
                  );
              }
            },
            connectorBuilder: (_, index, __) {
              final prevCompleted = index > 0
                  ? checkpoints[index - 1].state == CheckpointState.completed
                  : false;
              final isActive =
                  checkpoints[index].state == CheckpointState.completed ||
                  prevCompleted;
              return SolidLineConnector(
                thickness: 3,
                color: isActive
                    ? Color.fromRGBO(92, 230, 92, 1)
                    : Color.fromRGBO(117, 117, 117, 1),
              );
            },
            // Fix each content width to itemWidth
            contentsBuilder: (_, index) {
              final checkpoint = checkpoints[index];
              return SizedBox(
                width: itemWidth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    checkpoint.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.h7.w300,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

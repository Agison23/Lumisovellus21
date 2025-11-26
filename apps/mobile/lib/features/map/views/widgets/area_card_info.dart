import 'package:flutter/material.dart';
import 'package:lumisovellus/core/common/time_ago.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

class AreaCardInfo extends StatelessWidget {
  final AppLocalizations t;
  final String danger;
  final List<SnowType> snowTypes;
  final GuideUpdateRequestOutput? guideUpdate;
  final List<SegmentUserReview> userReviews;
  final VoidCallback onAdd;
  final VoidCallback onClose;
  final bool canAddObservation;

  const AreaCardInfo({
    required this.t,
    required this.danger,
    required this.snowTypes,
    required this.guideUpdate,
    required this.userReviews,
    required this.onAdd,
    required this.onClose,
    required this.canAddObservation,
    super.key,
  });

  SnowType? _findSnowType(String id) {
    for (final st in snowTypes) {
      if (st.id == id) return st;
    }
    return null;
  }

  String _hazardLabel(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  String _daysAgoText(DateTime submittedAt) {
    return t.timeAgo(submittedAt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final guide = guideUpdate;

    final primaryIds = guide?.primarySnowTypeIds ?? const [];
    final secondaryIds = guide?.secondarySnowTypeIds ?? const [];
    final guideHazards = guide?.hazards ?? const [];

    final reviews = [...userReviews]
      ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    final hasReviews = reviews.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(danger, style: const TextStyle(fontSize: 14, color: Colors.black)),
        const SizedBox(height: 8),
        if (guide != null) ...[
          for (final id in primaryIds)
            if (id.isNotEmpty)
              GuideSnowTypeRow(snowType: _findSnowType(id), isPrimary: true),
          for (final id in secondaryIds)
            if (id.isNotEmpty)
              GuideSnowTypeRow(snowType: _findSnowType(id), isPrimary: false),
          if (guide.description != null && guide.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(guide.description!, style: theme.textTheme.bodySmall),
          ],
          if (guideHazards.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '${t.guideHazards}: ${guideHazards.join(', ')}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
        if (guide != null && hasReviews) ...[
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
        ] else if (guide != null) ...[
          const SizedBox(height: 12),
        ],
        if (hasReviews) ...[
          Text(
            t.guideInfoFromUsers,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          ...reviews.map((review) {
            final mainSnowType = _findSnowType(review.snowTypeId);
            final name = mainSnowType?.name ?? review.snowTypeId;
            final desc = mainSnowType?.explanation ?? '';

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name: ${_daysAgoText(review.submittedAt)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(desc, style: const TextStyle(fontSize: 12)),
                  ],
                  if (review.hazards.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${t.obstacles}: ${review.hazards.map(_hazardLabel).join(', ')}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canAddObservation)
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                ),
                child: Text(t.addObservation),
              ),
            if (canAddObservation) const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onClose,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 243, 243, 243),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
              ),
              child: Text(t.close),
            ),
          ],
        ),
      ],
    );
  }
}

class GuideSnowTypeRow extends StatelessWidget {
  final SnowType? snowType;
  final bool isPrimary;

  const GuideSnowTypeRow({
    required this.snowType,
    required this.isPrimary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (snowType == null) return const SizedBox.shrink();

    final titleSize = isPrimary ? 16.0 : 14.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snowType!.name,
            style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w600),
          ),
          if ((snowType!.explanation ?? '').isNotEmpty)
            Text(snowType!.explanation!, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

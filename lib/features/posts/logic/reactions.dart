import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum Reactions {
  like,
  celebrate,
  support,
  love,
  insightful,
  funny,
}

Reactions? parseReactions(String? json) {
  switch (json) {
    case 'Like':
      return Reactions.like;
    case 'Celebrate':
      return Reactions.celebrate;
    case 'Support':
      return Reactions.support;
    case 'Love':
      return Reactions.love;
    case 'Insightful':
      return Reactions.insightful;
    case 'Funny':
      return Reactions.funny;
    default:
      return null;
  }
}

Reaction<Reactions?> getReaction(Reactions? reaction,
    {bool isComment = false, double commentIconSize = 18}) {
  switch (reaction) {
    case Reactions.like:
      return Reaction(
        value: Reactions.like,
        icon: Icon(
          LucideIcons.thumbsUp,
          color: Colors.blue,
          size: isComment ? commentIconSize : 24,
        ),
      );
    case Reactions.celebrate:
      return Reaction(
        value: Reactions.celebrate,
        icon: Icon(
          LucideIcons.partyPopper,
          color: Colors.pink,
          size: isComment ? commentIconSize : 24,
        ),
      );
    case Reactions.support:
      return Reaction(
        value: Reactions.support,
        icon: Icon(
          LucideIcons.helpingHand,
          color: Colors.green.shade600,
          size: isComment ? commentIconSize : 24,
        ),
      );
    case Reactions.funny:
      return Reaction(
        value: Reactions.funny,
        icon: Icon(
          LucideIcons.laugh,
          color: Colors.purple.shade600,
          size: isComment ? commentIconSize : 24,
        ),
      );
    case Reactions.love:
      return Reaction(
        value: Reactions.love,
        icon: Icon(
          LucideIcons.heart,
          color: Colors.red.shade600,
          size: isComment ? commentIconSize : 24,
        ),
      );
    case Reactions.insightful:
      return Reaction(
        value: Reactions.insightful,
        icon: Icon(
          LucideIcons.lightbulb,
          color: Colors.yellow.shade600,
          size: isComment ? commentIconSize : 24,
        ),
      );
    default:
      return Reaction(
        value: null,
        icon: Icon(
          LucideIcons.smilePlus,
          size: isComment ? commentIconSize : 24,
        ),
      );
  }
}

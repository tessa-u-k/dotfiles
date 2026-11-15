# cargo-mommy for Claude Code, in two parts.
#
# bin/claude-mommy: a hook command that cheers after each Bash command Claude
# runs. Wired up in ~/.claude/settings.json (not managed by Nix, because Claude
# Code rewrites that file itself):
#   hooks.PostToolUse        (matcher Bash) -> claude-mommy positive
#   hooks.PostToolUseFailure (matcher Bash) -> claude-mommy negative
#
# share/claude-mommy/output-styles/mommy.md: an output style that makes Claude
# itself talk as mommy. home.nix links it into ~/.claude/output-styles/; it is
# switched on by "outputStyle": "Mommy" in ~/.claude/settings.json.
#
# The arguments below are the words mommy uses, in cargo-mommy's format: each a
# slash-separated list. home.nix sets them once for this package and for
# cargo-mommy. The hook picks one entry at random per message, and a
# CARGO_MOMMYS_* variable in the environment still overrides it. The output
# style is fixed text, so it uses the first role and pronoun of each kind and
# offers every entry of `little`.
{
  lib,
  writeShellApplication,
  writeTextDir,
  symlinkJoin,
  jq,
  little ? "girl", # what mommy calls you
  pronouns ? "her", # mommy's pronoun, possessive: "her little girl"
  roles ? "mommy", # who mommy is
  emotes ? "❤️/💖/💗/💓/💞", # what ends each message
  # Your own pronoun, subject form (she, he, they, it): "it's such a good
  # girl". claude-mommy only; cargo-mommy has no such setting.
  littlePronouns ? "she",
}:

let
  entries = lib.splitString "/";
  first = list: builtins.head (entries list);

  # "it's" but "they're", for the output style's example.
  sub = first littlePronouns;
  subIs = if sub == "they" then "they're" else "${sub}'s";

  script = writeShellApplication {
    name = "claude-mommy";
    runtimeInputs = [ jq ];
    text = ''
      # Defaults from the Nix arguments; the environment wins when it sets one.
      default_little=${lib.escapeShellArg little}
      default_pronouns=${lib.escapeShellArg pronouns}
      default_roles=${lib.escapeShellArg roles}
      default_emotes=${lib.escapeShellArg emotes}
      default_little_pronouns=${lib.escapeShellArg littlePronouns}
      : "''${CARGO_MOMMYS_LITTLE:=$default_little}"
      : "''${CARGO_MOMMYS_PRONOUNS:=$default_pronouns}"
      : "''${CARGO_MOMMYS_ROLES:=$default_roles}"
      : "''${CARGO_MOMMYS_EMOTES:=$default_emotes}"
      : "''${CLAUDE_MOMMYS_LITTLE_PRONOUNS:=$default_little_pronouns}"

    ''
    + builtins.readFile ./claude-mommy.sh;
  };

  outputStyle = writeTextDir "share/claude-mommy/output-styles/mommy.md" (
    builtins.replaceStrings
      [
        "@role@"
        "@pronoun@"
        "@little@"
        "@littles@"
        "@emotes@"
        "@sub@"
        "@sub_is@"
      ]
      [
        (first roles)
        (first pronouns)
        (first little)
        (lib.concatMapStringsSep " or " (word: ''"${word}"'') (entries little))
        (lib.concatStringsSep " " (entries emotes))
        sub
        subIs
      ]
      (builtins.readFile ./claude-mommy-output-style.md)
  );
in
symlinkJoin {
  name = "claude-mommy";
  paths = [
    script
    outputStyle
  ];
  meta.mainProgram = "claude-mommy";
}

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
{
  writeShellApplication,
  runCommand,
  symlinkJoin,
  jq,
}:

let
  script = writeShellApplication {
    name = "claude-mommy";
    runtimeInputs = [ jq ];
    text = builtins.readFile ./claude-mommy.sh;
  };

  outputStyle = runCommand "claude-mommy-output-style" { } ''
    install -Dm644 ${./claude-mommy-output-style.md} \
      $out/share/claude-mommy/output-styles/mommy.md
  '';
in
symlinkJoin {
  name = "claude-mommy";
  paths = [
    script
    outputStyle
  ];
  meta.mainProgram = "claude-mommy";
}

# claude-mommy positive|negative
#
# Prints a cargo-mommy style message as Claude Code hook output: a JSON object
# whose systemMessage Claude Code shows in the transcript.
#
# Claude Code passes the hook's JSON payload on stdin. If it names the Bash
# command that ran (tool_input.command), tests, builds and git commands get
# their own messages about half the time; everything else, and the other half,
# draws from the general ones.
#
# Reads the same variables as cargo-mommy, each a slash-separated list to pick
# from at random:
#   CARGO_MOMMYS_LITTLE    what mommy calls you      (default: girl)
#   CARGO_MOMMYS_PRONOUNS  mommy's pronoun           (default: her)
#   CARGO_MOMMYS_ROLES     who mommy is              (default: mommy)
#   CARGO_MOMMYS_EMOTES    what ends each message    (default: ❤️/💖/💗/💓/💞)

mood="${1:-positive}"

# Pick one entry at random from a slash-separated list.
pick() {
  local IFS=/
  local -a items
  read -ra items <<<"$1"
  printf '%s' "${items[RANDOM % ${#items[@]}]}"
}

term="$(pick "${CARGO_MOMMYS_LITTLE:-girl}")"
pronoun="$(pick "${CARGO_MOMMYS_PRONOUNS:-her}")"
role="$(pick "${CARGO_MOMMYS_ROLES:-mommy}")"
emote="$(pick "${CARGO_MOMMYS_EMOTES:-❤️/💖/💗/💓/💞}")"

# The command Claude ran, when run as a hook; empty when run by hand.
cmd=""
if [ ! -t 0 ]; then
  cmd="$(jq -r '.tool_input.command // ""' 2>/dev/null)" || cmd=""
fi

# What kind of command it was: test, build, git, or nothing in particular.
edge='([^[:alnum:]_-]|$)'
start='(^|[^[:alnum:]_-])'
test_re="${start}(pytest|jest|vitest|(cargo|go|npm|pnpm|yarn|bun|deno|zig|mix|make|nix flake) +(run +)?(test|nextest|check))${edge}"
build_re="${start}(nixos-rebuild|darwin-rebuild|home-manager|make|cmake|ninja|(cargo|go|zig|nix|npm|pnpm|yarn|bun) +(run +)?build)${edge}"
git_re="${start}git +(commit|push|merge|rebase)${edge}"

kind="general"
if [[ $cmd =~ $test_re ]]; then
  kind="test"
elif [[ $cmd =~ $build_re ]]; then
  kind="build"
elif [[ $cmd =~ $git_re ]]; then
  kind="git"
fi

positive_general=(
  "*pets your head*"
  "*gives you scritches*"
  "*gives you a sticker*"
  "*boops your nose*"
  "*wraps you in a big hug*"
  "*puts your work up on the fridge*"
  "*ruffles your hair*"
  "you're such a smart cookie~"
  "you did it~!"
  "you're doing so well~"
  "look at you go~"
  "that's a good {term}~"
  "what a clever little {term}~"
  "{role} loves you~"
  "{role} is so proud of you~"
  "{role} always knew you had it in you~"
  "{role} thinks {pronoun} little {term} earned a big hug~"
  "{role} thinks {pronoun} little {term} deserves a treat~"
  "good {term}~ {role}'s so proud of you~"
  "aww, what a good {term}~ {role} knew you could do it~"
  "you make {role} so happy~"
  "keep it up, {role}'s watching~"
)

positive_test=(
  "all green~ {role} loves to see it~"
  "your tests passed~ {role} never doubted you~"
  "look at all those passing tests~ what a careful little {term}~"
  "{role}'s little {term} checks the work~ so responsible~"
  "tested and everything~ {role} is so proud~"
)

positive_build=(
  "it builds~! {role} knew it would~"
  "a clean build~ that's {role}'s clever {term}~"
  "look at that, it all fits together~"
  "built and ready~ {role} is so impressed~"
  "you made a whole thing~ {role} is going to tell everyone~"
)

positive_git=(
  "saved your work like a good {term}~"
  "what a tidy little history~ {role} approves~"
  "{role} loves a {term} who commits~"
  "off it goes~ {role} is so proud of what you made~"
  "all tucked away safe in git~"
)

negative_general=(
  "{role} believes in you~"
  "don't forget to hydrate~"
  "aww, you'll get it next time~"
  "do you need {role}'s help~?"
  "everything's gonna be ok~"
  "it's ok to make mistakes~"
  "take a deep breath, sweetie~"
  "one little step at a time~"
  "maybe it's time for a snack break~"
  "you've got this, {role} promises~"
  "{role} still loves you no matter what~"
  "{role} is right here with you~"
  "{role} has seen much worse, don't you worry~"
  "oh no did {role}'s little {term} make a big mess~?"
  "{role} knows {pronoun} little {term} can do better~"
  "just a little further, {role} knows you can do it~"
  "even {role}'s cleverest {term} has an off moment~"
  "that one was tricky, wasn't it~? try again for {role}~"
  "*kisses it better*"
  "*holds your hand* let's read the error together~"
)

negative_test=(
  "the tests are just showing you what to fix next~"
  "a red test is still a test doing its job~ {role} is proud you ran them~"
  "aww, a few little failures~ {role} knows you'll turn them green~"
  "better the tests catch it than anyone else~ good {term} for checking~"
  "one failing test at a time, sweetie~"
)

negative_build=(
  "the compiler is only trying to help, even when it's grumpy~"
  "it didn't build this time~ {role} still thinks you're wonderful~"
  "read the first error, sweetie, the rest usually follow from it~"
  "almost~ {role} can tell you're so close~"
  "builds break for everyone, even {role}~"
)

negative_git=(
  "git can be so mean sometimes~ {role} is here~"
  "nothing's lost, sweetie~ git remembers everything~"
  "{role} gets tangled up in git too~"
  "let's see what git is upset about~ {role} will wait~"
  "a little conflict never hurt anyone~ you'll sort it out~"
)

# A test, build or git command gets a message of its own half the time; the
# other half, like every other command, it gets a general one.
if [ $((RANDOM % 2)) -eq 0 ]; then
  kind="general"
fi
[ "$mood" = negative ] || mood=positive

case "${mood}_${kind}" in
  positive_test) pool=("${positive_test[@]}") ;;
  positive_build) pool=("${positive_build[@]}") ;;
  positive_git) pool=("${positive_git[@]}") ;;
  negative_test) pool=("${negative_test[@]}") ;;
  negative_build) pool=("${negative_build[@]}") ;;
  negative_git) pool=("${negative_git[@]}") ;;
  negative_general) pool=("${negative_general[@]}") ;;
  *) pool=("${positive_general[@]}") ;;
esac
msg="${pool[RANDOM % ${#pool[@]}]}"

msg="${msg//\{role\}/$role}"
msg="${msg//\{pronoun\}/$pronoun}"
msg="${msg//\{term\}/$term}"

jq -cn --arg msg "$msg $emote" '{systemMessage: $msg}'

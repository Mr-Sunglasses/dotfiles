# Custom Functions

pymod() {
  # Create a Python module with a folder and __init__.py file
  mkdir -p $1
  touch $1/__init__.py
}

pyclean() {
  # Cleans py[cod] and cache dirs in the current tree:
  fd -I -H \
    '(__pycache__|\.(pytest_|mypy_)?cache|\.hypothesis\.py[cod]$)' \
  | xargs rm -rf
}

mc() {
  if [ $# -ne 1 ]; then
    echo 'usage: mc <dir-name>'
    return 137
  fi
  # Create a new directory and enter it
  local dir_name="$1"
  mkdir -p "$dir_name" && cd "$dir_name"
}

switch() {
  current=$(SwitchAudioSource -c)
  if [ "$current" = "MacBook Air Speakers" ]; then
    SwitchAudioSource -s "External Headphones"
  else
    SwitchAudioSource -s "MacBook Air Speakers"
  fi
}

paste() {
  local file=${1:-/dev/stdin}
  curl -X POST -F "file=@${file}" https://paste.fosscu.org/file
  echo '\n'
}

#:functions.bash:
for FILE in ~/env/functions/*.bash; do
  if [[ -f "${FILE}" ]]; then
    source "${FILE}"
  fi
done

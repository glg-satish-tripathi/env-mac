for FILE in ~/env-ubuntu/functions/*.bash; do
  if [[ -f "${FILE}" ]]; then
    source "${FILE}"
  fi
done

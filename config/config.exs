import Config
# required for mime to support gemini files
config :mime, :types, %{"text/gemini" => ["gmi", "gemini"]}

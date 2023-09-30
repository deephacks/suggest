
# install using nimble
build:
  nimble install

# suggest 5 top words with distance 2 using the standard linux word dictionary, which contains around 100k lines.
suggest word='hacking':
  suggest -n5 --distance 2 < /usr/share/dict/words hacking

## To set any sell just do this 
I use fish btw
```shell
  chsh -s $(which fish)
```

## Also for root 
```shell
  sudo chsh -s $(which fish) root
```

## Now change some configs of fish  
```fish
if status is-interactive
    functions --erase fish_greeting
end
```

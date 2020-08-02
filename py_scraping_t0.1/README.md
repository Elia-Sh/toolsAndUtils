

# py scraper

The utility allows one to send requests via publicly available proxies.

It's an educational and designed to test my own environments, do not use it on production sites.

## Getting Started

1. git clone; venv activate; pip install

2. import scrape_utils into you project - 
```
    import scrape_utils

    proxy_scrambler = scrape_utils.ProxyScrambler()
    proxy_scrambler.proxy_list              # a list of proxies
    proxy_scrambler.user_agent_strings_list # a list of user agents
    
    proxy_scrambler.send_scrambled_request(<url>)

```


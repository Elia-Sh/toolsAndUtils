import requests
from bs4 import BeautifulSoup
import random
import re

JUST_A_USER_AGENT_STRING = ('Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
                            'AppleWebKit/537.36 (KHTML, like Gecko)'
                            'Chrome/74.0.3729.169 Safari/537.36')

class ProxyObj:
    """
    A class for wanted proxy attributes
    """
    def __init__(self, ip_address, port, country):
        self.ip_address = ip_address
        self.port = port
        self.country = country

    def __repr__(self):
        return (f'{self.__class__.__name__}('
           f'{self.ip_address!r}, {self.port!r}, {self.country!r})')

    def __str__(self):
        return '{}'.format(repr(self))

class ProxyScrambler:
    """
    A class for sending requests via proxies,
    defined to test if url exists using HEAD request;
        https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/HEAD
    """
    def __init__(self):
        self.proxy_list = self.get_proxies_obj_list()
        self.user_agent_strings_list = self.get_user_agent_strings_list()

    def send_scrambled_request(self, url='', max_attempts = 5):
        response = None
        attempts_counter = 0

        while ((attempts_counter < max_attempts) and
                (response is None) and 
                (len(self.proxy_list) > 0 )):
            random_user_agent = random.choice(self.user_agent_strings_list)
            random_proxy = random.choice(self.proxy_list)
            try:
                print('Trying url: {} via: {}'.format(url, random_proxy))
                # response = requests.get(url=url,
                response = requests.head(url=url,
                    proxies={
                        'http': '{}:{}'.format(random_proxy.ip_address, random_proxy.port),
                        'https': '{}:{}'.format(random_proxy.ip_address, random_proxy.port),
                        }, 
                    headers={'User-Agent': random_user_agent
                        },
                    allow_redirects = True, timeout=20
                    )
                print('PROXY PASS: successfully sent request #{} via: {}'.format(attempts_counter, random_proxy))

                if response.ok:
                    print("reached file: {}; it exists and can be downloaded!".format(request_counter))
                elif response.status_code == 403:
                    # forbidden file - 403 means no such file 
                    # source: https://aws.amazon.com/premiumsupport/knowledge-center/s3-troubleshoot-403/
                    # 404 is saved for if properly configured s3 permission -> s3:ListBucket.
                    # continue
                    print("file {} not found, got 403 Forbidden".format(request_counter))
                else: 
                    # something else got wrong
                    print("Unexpected error")
                    response.raise_for_status()
            except requests.exceptions.ProxyError:
                print('PROXY FAIL: failed to access request via: {}'.format(random_proxy))
                self.proxy_list.remove(random_proxy) # remove the failing proxy from the list.
                attempts_counter+=1
        if response is None and attempts_counter >= max_attempts:
            print('max attempts of: {} for url: {}reached'.format(
                max_attempts, url
            ))

        return response
    
    @staticmethod
    def get_proxies_obj_list():
        """
        inspired by: https://www.scrapehero.com/how-to-rotate-proxies-and-ip-addresses-using-python-3/
        """
        proxies_obj_list = []
        url = 'https://free-proxy-list.net/'
        response = requests.get(url,
            headers={'User-Agent': JUST_A_USER_AGENT_STRING})
        soup_proxies = BeautifulSoup(response.text, 'html.parser')
        proxies_td_with_https_list = soup_proxies.find_all("td", class_="hx", text="yes")
        proxies_tr_with_https_list = [_.find_parent() for _ in proxies_td_with_https_list]
        for proxy_record in proxies_tr_with_https_list:
            proxy_record_tds_list = proxy_record.find_all()
            proxy_record_obj = ProxyObj(proxy_record_tds_list[0].text,
            proxy_record_tds_list[1].text, proxy_record_tds_list[3].text)
            proxies_obj_list.append(proxy_record_obj)
        return proxies_obj_list

    @staticmethod
    def get_user_agent_strings_list():
        # use headers to specify client type -> fake some firefox/chrome etc.
        url = 'https://developers.whatismybrowser.com/useragents/explore/software_type_specific/web-browser/'
        response = requests.get(url,
            headers={'User-Agent': JUST_A_USER_AGENT_STRING})
        soup = BeautifulSoup(response.text, 'html.parser')
        # example of the wanted node at: whatismybrowser.com/useragents - 
        #   <a href="/useragents/parse/1240908-webkit-based-browser-ios-iphone-webkit">Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148</a>
        elements_list = soup.find_all('a', href=re.compile('/useragents/parse/\d'))
        user_agent_strings_list = [a.get_text() for a in elements_list]
        return user_agent_strings_list

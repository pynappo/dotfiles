#include <algorithm>
#include <array>
#include <bits/stdc++.h>
#include <cstring>
#include <ios>
#include <unordered_map>
using namespace std;

// clang-format off
typedef long long ll;
typedef long double ld;
typedef vector<ll> vec;
typedef pair<ll, ll> pl;
typedef vector<pair<ll, ll> > vll;
#define pb push_back
#define all(x) (x).begin(), (x).end()
#define f(i,l,r) for (ll i = l; i < r; ++i)
#define fd(i,r,l) for (ll i = r; i >= l; --i)
#define r(x) ll x; cin >> x;
#define rd(x) ld x; cin >> x;
#define rs(s) string s; cin >> s;
#define rc(c) char c; cin >> c;
#define rv(a,n) vec a(n); f(i, 0, n) cin >> a[i];
#define rnv(a) r(n); rv(a,n);
#define pv(a) f(i, 0, a.size()) {cout << a[i] << endl;} cout << endl;
#define TC ll ntests;cin>>ntests;ll tc=0;goto _restart;_restart:;while(++tc<=ntests)
#define o(x) {cout<<x<<'\n'; goto _restart;}
#define ov(a) {pv(a) goto _restart;}
// clang-format on

int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(NULL);
  r(people);
  r(messages_sent);
  ll sender;
  unordered_map<ll, ll> last_time_sent;
  ll unread_messages = 0;
  vec res;
  f(timestamp, 0, messages_sent) {
    cin >> sender;
    unread_messages -= timestamp - last_time_sent[sender];
    last_time_sent[sender] = timestamp + 1;
    // cout << unread_messages << endl;
    // sent to all people minus the current sender
    unread_messages += people - 1;
    cout << unread_messages << endl;
  }
}

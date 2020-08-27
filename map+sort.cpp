#include <bits/stdc++.h>

using namespace std;

// Complete the sherlockAndAnagrams function below.
int sherlockAndAnagrams(string s) {
    string sn, ss;
    map<string, int> mp;
    int j;
    int l = s.length();
    for (int k = 0;k < l;k++) {   // 创造一个字典，把所有n(n-1)/2个词都放进去了(加法原理)
        ss = "";
        for (int i = 0;i < l - k;i++) {
            j = k + i;
            ss = ss + s[j];
            sn = ss;
            sort(sn.begin(), sn.end());   // 字符串自己排序后就没有顺序之分了
            mp[sn]++;
        }
    }
    long long int ans = 0;
    map<string, int> ::iterator it;
    for (it = mp.begin(); it != mp.end(); it++) {
        long long  vl = (long long)(it->second);
        if (vl > 1) {
            ans += (vl * (vl - 1)) / 2LL;  //2LL是long long，如果换成int就是2
        }
    }
    return ans;
    /*int ans = 0;
    map<string, int> ::iterator it;
    for (it = mp.begin(); it != mp.end(); it++) {
        int vl = it->second;
        if (vl > 1) {
            ans += (vl * (vl - 1)) / 2;
        }
    }*/

}

int main()
{
    ofstream fout(getenv("OUTPUT_PATH"));

    int q;
    cin >> q;
    cin.ignore(numeric_limits<streamsize>::max(), '\n');

    for (int q_itr = 0; q_itr < q; q_itr++) {
        string s;
        getline(cin, s);

        int result = sherlockAndAnagrams(s);

        fout << result << "\n";
    }

    fout.close();

    return 0;
}

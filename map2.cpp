#include <bits/stdc++.h>

using namespace std;

// Complete the makeAnagram function below.
int makeAnagram(string a, string b) {
    int m = a.length();
    int n = b.length();
    map<string, int> ma;
    map<string, int> mb;
    string s = "";
    for (int i = 0; i < m; i++)
    {
        s = a[i];
        ma[s]++;
    }
    for (int i = 0; i < n; i++)
    {
        s = b[i];
        mb[s]++;
    }
    map<string, int> ::iterator it;
    int sum = 0;
    for (it = mb.begin(); it != mb.end(); it++)
    {
        if (ma[it->first] < it->second)
        {
            sum += abs(ma[it->first] - it->second);
        }
    }
    for (it = ma.begin(); it != ma.end(); it++)
    {
        if (mb[it->first] < it->second)
        {
            sum += abs(mb[it->first] - it->second);
        }
    }

    return sum;



}

int main()
{
    ofstream fout(getenv("OUTPUT_PATH"));

    string a;
    getline(cin, a);

    string b;
    getline(cin, b);

    int res = makeAnagram(a, b);

    fout << res << "\n";

    fout.close();

    return 0;
}
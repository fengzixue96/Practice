#include <bits/stdc++.h>

using namespace std;

// Complete the twoStrings function below.
string twoStrings(string s1, string s2) {
    map <char, int> k;
    int counter = 0;
    for (int y = 0;y < s1.length(); y++)  // string use ".length" 
        k[s1[y]]++;                       // 将s1的substring加入k
    for (int y = 0;y < s2.length(); y++)  // 在k中查找s2中的substring
        if (k[s2[y]])
            counter = 1;

    if (counter)
        return "YES";
    else
        return "NO";
}
//和map.cpp不同，后者需要比较个数，所以建立两个map；前者只需确定是否有重复的内容。

int main()
{
    ofstream fout(getenv("OUTPUT_PATH"));

    int q;
    cin >> q;
    cin.ignore(numeric_limits<streamsize>::max(), '\n');

    for (int q_itr = 0; q_itr < q; q_itr++) {
        string s1;
        getline(cin, s1);

        string s2;
        getline(cin, s2);

        string result = twoStrings(s1, s2);

        fout << result << "\n";
    }

    fout.close();

    return 0;
}

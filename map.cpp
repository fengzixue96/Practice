// 两个字符串数组，看note中的所有单词都能在magazine中找到，且数量：note < magazine

#include <bits/stdc++.h>

using namespace std;

vector<string> split_string(string);

// Complete the checkMagazine function below.
void checkMagazine(vector<string> magazine, vector<string> note) {
    int m = magazine.size();
    int n = note.size();
    map<string, int> ma;
    map<string, int> no;
    for (int i = 0; i < m; i++)
        ma[magazine[i]]++;
    for (int i = 0; i < n; i++)
        no[note[i]]++;
    map<string, int> ::iterator it;
    bool success = 1;
    for (it = no.begin(); it != no.end(); it++) { // map(如no)的循环内容是互不相同的
        if (ma[it->first] < it->second) { // it->second还可写为ma[it->first]或ma[no[1]]
            //(*it).first will give you the key(实际值) and (*it).second will give you the value(个数)
            //比较个数： magazine < note => unsuccessful
            //it为中介
            success = 0;
            break;
        }
    }
    if (success) {
        cout << "Yes";
    }
    else {
        cout << "No";
    }


}

int main()
{
    string mn_temp;
    getline(cin, mn_temp);

    vector<string> mn = split_string(mn_temp);

    int m = stoi(mn[0]);

    int n = stoi(mn[1]);

    string magazine_temp_temp;
    getline(cin, magazine_temp_temp);

    vector<string> magazine_temp = split_string(magazine_temp_temp);

    vector<string> magazine(m);

    for (int i = 0; i < m; i++) {
        string magazine_item = magazine_temp[i];

        magazine[i] = magazine_item;
    }

    string note_temp_temp;
    getline(cin, note_temp_temp);

    vector<string> note_temp = split_string(note_temp_temp);

    vector<string> note(n);

    for (int i = 0; i < n; i++) {
        string note_item = note_temp[i];

        note[i] = note_item;
    }

    checkMagazine(magazine, note);

    return 0;
}

vector<string> split_string(string input_string) {
    string::iterator new_end = unique(input_string.begin(), input_string.end(), [](const char& x, const char& y) {
        return x == y and x == ' ';
        });

    input_string.erase(new_end, input_string.end());

    while (input_string[input_string.length() - 1] == ' ') {
        input_string.pop_back();
    }

    vector<string> splits;
    char delimiter = ' ';

    size_t i = 0;
    size_t pos = input_string.find(delimiter);

    while (pos != string::npos) {
        splits.push_back(input_string.substr(i, pos - i));

        i = pos + 1;
        pos = input_string.find(delimiter, i);
    }

    splits.push_back(input_string.substr(i, min(pos, input_string.length()) - i + 1));

    return splits;
}

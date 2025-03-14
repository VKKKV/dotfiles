import os
import string


jianpin_word_map = {}
file_list = ["base.dict.yaml", "ext.dict.yaml"]
for file in file_list:
    file_name = os.path.join("cn_dicts", file)
    with open(file_name, "r") as file:
        # 逐行读取文件内容
        for line in file:
            # 去除行尾的换行符
            line = line.rstrip()
            if line.startswith("#") or "\t" not in line:
                continue
            params = line.split("\t")
            word = params[0]
            encode = params[1]
            freq = params[2]

            if len(word) != 2:
                continue
            pinyin = params[1]
            shengmus = pinyin.split(" ")
            jianpin = shengmus[0][0] + shengmus[1][0]

            word_freq = {}
            word_freq["word"] = word
            word_freq["freq"] = freq

            key = word + encode
            if key not in jianpin_word_map:
                jianpin_word_map[key] = word_freq
            else:
                print("重复" + word)
                print(jianpin_word_map[key])

print(jianpin_word_map["什么shen me"])

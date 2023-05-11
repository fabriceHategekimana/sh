import sys


def remove_minus(text):
    pos = text.find("-")
    return (text if pos == -1 else text[pos+2:]).replace(" ", "_")


entry = " ".join(sys.argv[1:])
text, text_type = entry.split(" :: ")
text = remove_minus(text)

print(f"{text}\n{text_type}")

import json
import time
from deep_translator import GoogleTranslator

def translate_dict(d, translator, delay=0.1):
    translated = {}
    for k, v in d.items():
        if isinstance(v, dict):
            translated[k] = translate_dict(v, translator, delay)
        elif isinstance(v, str):
            try:
                # Basic protection for variables like {variable}
                # Google translate sometimes messes up {} so we need to be careful
                # For this script we will just translate raw
                translated[k] = translator.translate(v)
                print(f"Translated: {v[:20]}... -> {translated[k][:20]}...")
            except Exception as e:
                print(f"Error translating {v}: {e}")
                translated[k] = v
            time.sleep(delay)
        else:
            translated[k] = v
    return translated

def main():
    print("Loading ru.i18n.json...")
    with open('assets/translations/ru.i18n.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    translator = GoogleTranslator(source='ru', target='uk')
    print("Starting translation to Ukrainian...")
    
    translated_data = translate_dict(data, translator, delay=0.05)
    
    with open('assets/translations/uk.i18n.json', 'w', encoding='utf-8') as f:
        json.dump(translated_data, f, ensure_ascii=False, indent=2)
    
    print("Translation saved to uk.i18n.json")

if __name__ == '__main__':
    main()

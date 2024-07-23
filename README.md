# SpeCor: Specialized Correction for Enhanced ASR

Automatic Speech Recognition (ASR) technology has significantly advanced, yet it struggles with accurately transcribing speech from individuals with disorders like stuttering and lisping. SpeCor addresses these limitations by incorporating specialized correction mechanisms for these disorders, enhancing ASR accuracy and communication accessibility.

## Key Features

- **Minimalist Preprocessing**: Focuses on robust training with noise and data augmentation to simulate real-world conditions.
- **Feature Extraction**: Uses Mel-Frequency Cepstral Coefficients (MFCCs) to capture essential sound characteristics (i.e., phonemes).
- **Advanced Modeling**: Leverages the Whisper model along with the advanced GPT-2 tokenizer to process diverse speech patterns.
- **Impressive Results**: Evaluations using LibriSpeech and LibriStutter datasets show significant improvements in Word Error Rate (WER) for speech with impediments, reducing WER from 95.5% to 16%.
- **Efficient Architecture**: SpeCor’s architecture, featuring convolutional layers and transformer blocks, ensures stable and efficient training.

## API and Deployment

- **Kaggle API**: Used for data access and model training.
- **Deployment**: The model is deployed in a chat application using Python.

## Application Features

This app allows users to chat with others and convert voice chats (with or without stuttering) to text and vice versa. 

## Model Architecture

<img src="https://github.com/Abdelrahman-Fakhry-Hussein/SpeCor-Speech-Recognition-and-Stutter-Correction-Graduation-Project/blob/fffa24ad440ceda635c6f3605c963edf8ec13f13/SpeCor%20Model%20%26%20Inference%20%26%20Feature%20Extraction%20%26%20Preprocessing/Picture1.png" alt="SpeCor Model Architecture" width="700" height="500">

## Demo Video

<video src="https://github.com/Abdelrahman-Fakhry-Hussein/SpeCor-Speech-Recognition-and-Stutter-Correction-Graduation-Project/blob/62af3861dacdeebd05db3a7f3a0fec15cbd74675/SpeCor%20Flutter%20Application/Media1.mp4" width="700" height="500">

## Benefits

This innovation not only enhances the user experience for individuals with speech impediments but also paves the way for further advancements in assistive technologies. By addressing the unique challenges of speech disorders, SpeCor fosters a more inclusive digital future where everyone can communicate effortlessly using voice-based technologies.

## Future Work

- **Text-to-Speech**: Implementing a feature using the sender’s voice through the development of a one-shot speech synthesis model.
- **More Inclusive Datasets**: Training on more datasets containing a variety of speech impediments.
- **Enhanced Resources**: Utilizing more powerful resources for training.


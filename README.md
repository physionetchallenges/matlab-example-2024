# MATLAB example code for the George B. Moody PhysioNet Challenge 2024

## What's in this repository?

This repository contains a simple example that illustrates how to format a MATLAB entry for the [George B. Moody PhysioNet Challenge 2024](https://physionetchallenges.org/2024/). If you are participating in the 2024 Challenge, then we recommend using this repository as a template for your entry. You can remove some of the code, reuse other code, and add new code to create your entry. You do not need to use the models, features, and/or libraries in this example for your entry. We encourage a diversity of approaches for the Challenges.

For this example, we implemented a multinomial logistic regression model with several simple features. (This simple example is **not** designed to perform well, so you should **not** use it as a baseline for your approach's performance.) You can try it by running the following commands on the Challenge training set. If you are using a relatively recent personal computer, then you should be able to run these commands from start to finish on a small subset (1000 records) of the training data in less than 30 minutes.

## How do I run these scripts?

First, you can download and create data for these scripts by following the instructions in the "How do I create data for these scripts?" section in the [Python example code repository](https://github.com/physionetchallenges/python-example-2024).

Second, you can install the [WFDB](https://physionet.org/physiotools/wag/wag.htm) dependencies for these scripts by following the instructions on [this page](https://archive.physionet.org/physiotools/matlab/wfdb-app-matlab/).

You can train your model(s) by running

    train_model(training_data, model)

where

- `training_data` (input; required) is a folder with the training data files, including the images and diagnoses (you can use the `ptb-xl/records100/00000` folder from [these instructions](https://github.com/physionetchallenges/python-example-2024)); and
- `model` (output; required) is a folder for saving your model(s).

You can run your trained model(s) by running

    run_model(test_data, model, test_outputs)

where

- `test_data` (input; required) is a folder with the validation or test data files, excluding the images and diagnoses (you can use the `ptb-xl/records100_hidden/00000` folder from [these instructions](https://github.com/physionetchallenges/python-example-2024), but it would be better to repeat these steps on a new subset of the data that you did not use to train your model);
- `model` (input; required) is a folder for loading your model(s); and
- `test_outputs` is a folder for saving your model outputs.

The [Challenge website](https://physionetchallenges.org/2024/#data) provides a training database with a description of the contents and structure of the data files.

You can evaluate your model by pulling or downloading the [evaluation code](https://github.com/physionetchallenges/evaluation-2024) and running

    evaluate_model(labels, test_outputs, scores.csv)

where

- `labels` is a folder with labels for the data, such as the training database on the PhysioNet webpage (you can use the `ptb-xl/records100/00000` folder from [these instructions](https://github.com/physionetchallenges/python-example-2024), but it would be better to repeat these steps on a new subset of the data that you did not use to train your model);
- `test_outputs` is a folder containing files with your model's outputs for the data; and
- `scores.csv` (optional) is file with a collection of scores for your model.

## How do I create data for these scripts?

You can use the scripts in [this repository](https://github.com/physionetchallenges/python-example-2024) to generate synthetic ECG images for the [PTB-XL dataset](https://www.nature.com/articles/s41597-020-0495-6). You will need to generate or otherwise obtain ECG images before running the above steps.

## Which scripts I can edit?

Please edit the following script to add your code:

* `train_dx_model.m` is a script for training your dx classification model.
* `train_digitization_model.m` is a script for training your digitization model.
* `load_dx_model.m` is a script for loading your trained dx classification model.
* `load_digitization_model.m` is a script for loading your trained digitization model.
* `run_dx_model.m` is a script for running your trained dx classification model.
* `run_digitization_model.m` is a script for running your trained digitization model.

Please do **not** edit the following scripts. We will use the unedited versions of these scripts when running your code:

* `train_model.m` is a script for training your model(s).
* `run_model.m` is a script for running your trained model(s).

These scripts must remain in the root path of your repository, but you can put other scripts and other files elsewhere in your repository.

## How do I train, save, load, and run my model?

You can choose to create waveform reconstruction and/or classification models.

To train and save your model(s), please edit the `train_digitization_model.m` and `train_diagnosis_model.m` scripts. Please do not edit the input or output arguments of these function.

To load and run your trained model(s), please edit the `load_digitization_model.m`, `load_diagnosis_model.m`, `run_digitization_model.m`, and `run_diagnosis_model.m` scripts. Please do not edit the input or output arguments of the functions of these functions.

## What else do I need?

This repository does not include data or the code for generating ECG images. Please see the above instructions for how to download and prepare the data.

This repository does not include code for evaluating your entry. Please see the [evaluation code repository](https://github.com/physionetchallenges/evaluation-2024) for code and instructions for evaluating your entry using the Challenge scoring metric.

## How do I learn more? How do I share more?

Please see the [Challenge website](https://physionetchallenges.org/2024/) for more details. Please post questions and concerns on the [Challenge discussion forum](https://groups.google.com/forum/#!forum/physionet-challenges). Please do not make pull requests, which may share information about your approach.

## Useful links

* [Challenge website](https://physionetchallenges.org/2024/)
* [Python example code](https://github.com/physionetchallenges/python-example-2024)
* [Evaluation code](https://github.com/physionetchallenges/evaluation-2024)
* [Frequently asked questions (FAQ) for this year's Challenge](https://physionetchallenges.org/2024/faq/)
* [Frequently asked questions (FAQ) about the Challenges in general](https://physionetchallenges.org/faq/)

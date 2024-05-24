function [digitization_model, classification_model] = load_models(model_directory, verbose)

digitization_model=load(fullfile(model_directory,'digitalization_model'));

classification_model=load(fullfile(model_directory,'classification_model'));
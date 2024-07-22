from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse, JSONResponse
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel
import uvicorn
import os
import subprocess
import shutil
import time
import json
import glob
import requests


# Kaggle API Commands
# region
def kaggle_acc():
    os.environ['KAGGLE_USERNAME'] = 'mohamedlasheeen'
    os.environ['KAGGLE_KEY'] = '2ef4c287e44b2a431f34aeeb387a7dc0'


def execute_terminal_command(command):
    result = subprocess.run(command, shell=True, text=True, capture_output=True)
    return result.stdout, result.stderr


def init_kaggle_dataset(project_path):
    command = fr'kaggle datasets init -p {project_path}'
    return execute_terminal_command(command)


def create_kaggle_dataset(project_path):
    command = fr'kaggle datasets create -p {project_path} -r tar'
    return execute_terminal_command(command)


def pull_kaggle_dataset(project_path, dataset_id):
    command = fr'kaggle datasets metadata -p {project_path} {dataset_id}'
    return execute_terminal_command(command)


def update_kaggle_dataset(project_path):
    command = fr'kaggle datasets version -p {project_path} -m "Updated dataset using kaggle API 2024" -r tar'
    return execute_terminal_command(command)


def pull_kaggle_notebook(notebook_id, project_path):
    command = fr'kaggle kernels pull {notebook_id} -p {project_path} -m'
    return execute_terminal_command(command)


def push_kaggle_notebook(project_path):
    command = fr'kaggle kernels push -p {project_path}'
    return execute_terminal_command(command)


def get_notebook_status(notebook_id):
    command = fr'kaggle kernels status {notebook_id}'
    return execute_terminal_command(command)


def get_notebook_output(notebook_id, project_path):
    command = fr'kaggle kernels output {notebook_id} -p {project_path}'
    return execute_terminal_command(command)


# endregion

# Running Kaggle
# region
def wait_for_kernel_completion(kernel_id='abdelrhamanfakhry/gp-deployment', poll_interval=1):
    counter = 0
    while True:
        status = get_notebook_status(kernel_id)
        if "complete" in str(status) or "error" in str(status):
            print(f"Kernel status: {status}", "Time taken:", counter)
            break
        time.sleep(poll_interval)
        counter += poll_interval


def push_and_run_notebook(notebook_path='abdelrhamanfakhry/gp-deployment',
                          kernel_metadata_path='/content/notebook/kernel-metadata.json',
                          output_path='E:/SpeCor/assets'):
    push_command = f'kaggle kernels push -p {notebook_path}'
    print("Pushing the notebook to Kaggle...")
    push_output, push_error = execute_terminal_command(push_command)
    if push_error:
        print(f"Error pushing notebook: {push_error}")
        return

    # Assuming the kernel metadata JSON contains the kernel ID
    with open(kernel_metadata_path, 'r') as f:
        kernel_metadata = json.load(f)
    kernel_id = kernel_metadata['id']

    # Waiting for a fixed time period (e.g., 5 minutes) to allow the kernel to run
    print("Waiting for the notebook to run...")
    wait_for_kernel_completion()

    # Downloading the output
    download_command = f'kaggle kernels output {kernel_id} -p {output_path}'
    print("Downloading the notebook output...")
    download_output, download_error = execute_terminal_command(download_command)
    if download_error:
        print(f"Error downloading output: {download_error}")
        return

    return download_output


def get_dataset_and_update(dataset_path=r'/content/dataset', id="mohamedlasheeen/testdata"):
    pull_kaggle_dataset(dataset_path, id)
    update_kaggle_dataset(dataset_path)


def get_and_commit_notebook(nb_id='abdelrhamanfakhry/gp-deployment', nb_path=r'/content/notebook'):
    pull_kaggle_notebook(nb_id, nb_path)
    push_kaggle_notebook(nb_path)



# endregion

# Directory/File Handling
# region
def create_dir(path):
    if not os.path.exists(path):
        os.makedirs(path)


def upload_file(file_name, dest='E:/SpeCor/assets'):
    shutil.copy2(file_name, dest)


def read_file(file_name):
    with open(file_name, "r") as f:
        text = f.read()
    return text


def remove_non_json_files(directory):
    # Create the pattern for non-JSON files
    pattern = os.path.join(directory, '*')

    # Iterate over all files in the directory
    for file_path in glob.glob(pattern):
        # Check if the file has a .json extension
        if not file_path.endswith('.json'):
            try:
                os.remove(file_path)
                print(f'Removed: {file_path}')
            except OSError as e:
                print(f'Error removing {file_path}: {e}')


# endregion

app = FastAPI()

# Mount templates directory
templates = Jinja2Templates(directory="templates")


# Pydantic model for URL input
class AudioFileURL(BaseModel):
    url: str


# Homepage route
@app.get("/", response_class=FileResponse)
async def read_index():
    return "templates/index.html"


# Predict text route
@app.post("/predict")
async def predict_text(file_url: AudioFileURL):
    try:
        # Download the file from the provided URL
        response = requests.get(file_url.url)
        response.raise_for_status()

        # Save the file locally
        local_filename = "dataset/temp_audio_file.m4a"
        with open(local_filename, 'wb') as f:
            f.write(response.content)

        # Upload the file to the dataset directory
        #upload_file(local_filename)

        # Define paths for dataset and notebook
        dataset_path = r'dataset'
        nb_path = r'notebook'

        output_path = 'E:/SpeCor/assets'

        # Update dataset and commit notebook
        get_dataset_and_update(dataset_path)
        get_and_commit_notebook(nb_path=nb_path)

        # Run the notebook
        kernel_metadata_path = 'notebook/kernel-metadata.json'
        nb_id = 'abdelrhamanfakhry/gp-deployment'
        output = push_and_run_notebook(nb_id, kernel_metadata_path, output_path)

        # Read the transcription output
        text = read_file(f"{output_path}/transcription.txt")
        print(JSONResponse(content={"transcription": text}).body)
        return JSONResponse(content={"transcription": text})

    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=400, detail=f"Error downloading the file: {e}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error: {str(e)}")


# Predict audio route
@app.post("/predict/audio")
async def predict_audio(file_url: AudioFileURL):
    try:
        # Download the file from the provided URL
        response = requests.get(file_url.url)
        response.raise_for_status()

        # Save the file locally
        local_filename = "dataset/temp_audio_file.m4a"
        with open(local_filename, 'wb') as f:
            f.write(response.content)

        # Upload the file to the dataset directory
        upload_file(local_filename)

        # Define paths for dataset and notebook
        dataset_path = r'dataset'
        nb_path = r'notebook'
        output_path = 'E:/SpeCor/assets'

        # Update dataset and commit notebook
        get_dataset_and_update(dataset_path)
        get_and_commit_notebook(nb_path=nb_path)

        # Run the notebook
        kernel_metadata_path = 'notebook/kernel-metadata.json'
        nb_id = 'abdelrhamanfakhry/gp-deployment'
        output = push_and_run_notebook(nb_id, kernel_metadata_path, output_path)

        # Return the speech file path
        speech_path = f"{output_path}/speech.mp3"
        return JSONResponse(content={"speech_file": speech_path})

    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=400, detail=f"Error downloading the file: {e}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error: {str(e)}")


@app.get("/download")
async def download_file(file_path: str):
    return FileResponse(file_path)


if __name__ == "__main__":
    kaggle_acc()
    create_dir(r'notebook')
    create_dir(r'dataset')
    create_dir('E:/SpeCor/assets')

    with open('output/transcription.txt', 'w') as f:
        f.write("")
    remove_non_json_files(r'dataset')
    uvicorn.run(app, host="192.168.1.4", port=8000)

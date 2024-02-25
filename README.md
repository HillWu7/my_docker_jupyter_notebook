# my_docker_jupyter_notebook
Run Jupyter Notebook inside a Docker container

## Step 1: Clone this repository
```bash
git clone https://github.com/hillwu7/my_docker_jupyter_notebook.git
cd my_docker_jupyter_notebook
```

## Step 2: Set up the docker-compose file
The `docker-compose.yaml` file is already created. Ensure it contains the following content:

```yaml
version: '3'

services:
  my_docker_jupyter_notebook:
    image: my_docker_jupyter_notebook:latest
    ports:
      - 8888:8888
    volumes:
      - /sync_note:/app/sync_note
    environment:
      - JUPYTER_TOKEN=my_docker_jupyter_notebook_token
```

## Step 3: Start the Docker container with docker-compose
Make sure to change the path to the root of the `docker-compose.yaml` folder and run the following command:

```bash
docker-compose up 
```

This command builds the Docker image (if not already built) and starts the Jupyter Notebook server. Access the notebook at [http://localhost:8888/tree?token=my_docker_jupyter_notebook_token](http://localhost:8888/tree?token=my_docker_jupyter_notebook_token) in your web browser.

## Step 4: Stop and remove all services (Optional)
To stop and remove all services, use the following command:

```bash
docker-compose down 
```

This will shut down the running containers and remove associated networks and volumes.

## Alternative: Run with docker run command
If you prefer to run the container using docker run directly, you can use the following command:

```bash
docker run -p 8888:8888 -v ./sync_note:/app/sync_note -e JUPYTER_TOKEN=my_docker_jupyter_notebook_token my_docker_jupyter_notebook:latest
```

This command achieves the same result as the `docker-compose` setup. It maps the local `./sync_note` directory to `/app/sync_note` inside the container and sets the Jupyter Notebook token.

### Additional Information:
- Change the version of the image fetched from the repository with the `docker-compose.yaml` file at `image: my_docker_jupyter_notebook:latest`.
- The Jupyter Notebook token is set to `my_docker_jupyter_notebook_token`. Modify it by changing the `JUPYTER_TOKEN` environment variable in the `docker-compose.yaml` file.
- Notebooks are synced to the `/sync_note` directory inside the Docker container and mapped to `./sync_note` on your host machine. Adjust the host data path according to your preference.

---

## Docker Image Information
The Docker image is built based on `FROM` part at `DockerFile` as the parent image, yor can change it ify ou need.

The `environment.yaml` file under the `config` folder is used to create a Conda environment, which is activated during the image build.

The `Jupyter Notebook` is configured to run on port `8888`, which is exposed to the host machine.

### Dockerfile
```Dockerfile
# Use a specific version of Miniconda3 as a parent image
FROM continuumio/miniconda3:lastest

# Create a Conda environment from environment.yaml and activate it
RUN conda env create -f /app/config/environment.yaml && \
    conda run -n my_docker_jupyter_notebook /bin/bash -c "python -m ipykernel install --user --name=my_docker_jupyter_notebook --display-name=my_docker_jupyter_notebook" && \
    echo "export PATH=/opt/conda/envs/my_docker_jupyter_notebook/bin:$PATH" >> /etc/profile.d/conda.sh && \
    rm -rf /var/lib/apt/lists/*

# Make port 8888 available to the world outside this container
EXPOSE 8888

# Run Jupyter Notebook
CMD ["/bin/bash", "-c", "source activate my_docker_jupyter_notebook && jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root"]
```

---

### Image contents:
---

`my_docker_jupyter_notebook:1.0`

* base: `continuumio/miniconda3:23.10.0-1`
* package:
  * `python=3.10.13`
  * `jupyter=1.0.0`
  * `pandas=2.1.4`
  * `plotly=5.9.0`
  * `pyspark=3.4.1`

---


# Use a specific version of Miniconda3 as a parent image
FROM continuumio/miniconda3:23.10.0-1

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY config /app/config

# Create a Conda environment from environment.yaml and activate it
RUN conda env create -f /app/config/environment.yaml && \
    conda run -n my_docker_jupyter_notebook /bin/bash -c "python -m ipykernel install --user --name=my_docker_jupyter_notebook --display-name=my_docker_jupyter_notebook" && \
    echo "export PATH=/opt/conda/envs/my_docker_jupyter_notebook/bin:$PATH" >> /etc/profile.d/conda.sh && \
    rm -rf /var/lib/apt/lists/*

# Make port 8888 available to the world outside this container
EXPOSE 8888

# Run Jupyter Notebook
CMD ["/bin/bash", "-c", "source activate my_docker_jupyter_notebook && jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root","--NotebookApp.token=''","--NotebookApp.password=''"]
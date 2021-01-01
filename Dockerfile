FROM python:3.6.12

RUN mkdir /home/house_prices_kaggle

RUN pip install 'pandas==1.1.3' && \
    pip install 'numpy==1.19.1' && \
    pip install 'matplotlib==3.3.2' && \
    pip install 'seaborn==0.11.0' && \
    pip install 'arviz==0.10.0' && \
    pip install 'pystan==2.19.0.0' && \
    pip install jupyterlab

# Copy current local directory into container directory
COPY . /home/house_prices_kaggle/
#docker run -v /Users/benjaminwee/Documents/kaggle/house_prices_kaggle/:/home/house_prices_kaggle -it 'eating'

# Build docker image from docker file - call the image "eating"
# docker build . -t 'eating'

# Run image and open bash shell
# docker run -it 'eating' /bin/bash

# Run image and open bash shell + set volume mount (a joint folder between local and container)
# docker run -v /Users/benjaminwee/Documents/kaggle/house_prices_kaggle/:/home/house_prices_kaggle -it 'eating' /bin/bash

# Run image + bash + set volume mount + expose container port to random port on local machine (can specify more specifically)
# docker run -v /Users/benjaminwee/Documents/kaggle/house_prices_kaggle/:/home/house_prices_kaggle -p 8888  -it 'eating' /bin/bash

# Run jupyter lab in container
# jupyter lab --ip=0.0.0.0 --allow-root
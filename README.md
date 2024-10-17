This demo showcases Vector Search an AI-powered solution using new Oracle Database 23ai Free Edition.   
It is divided into two PL/SQL scripts for better understanding of the process. Below is a brief outline of each script's purpose, the steps followed in this demo, and the required environment setup.

Environment Requirements
Before running this demo, ensure your environment is configured as follows:

- Oracle Linux 8 or latter
- Oracle Database 23ai Free Release 23.5.0.24.07
- Oracle REST Data Services 24.2.3.r2011847

PL/SQL Script 1: Environment Setup
The first script is responsible for:

Defining the Tablespace
Creating the User Schema
Assigning the necessary Permissions

PL/SQL Script 2: Process Execution
The second script takes a step-by-step approach to building the solution. The key steps include:

Using Data Sources

Configuring the data sources that will feed the AI-driven features.
Enabling Document Loader with External Table Feature

Setting up external tables to load documents for processing.
Document Transformation

Performing transformations like:
Text Splitting
Summarization
Embedding Model

Using an embedding model to convert data into vectors for analysis.
Vector Database

Leveraging Oracle's vector database capabilities for storing and querying vectors.
Similarity Search

Implementing similarity search to find related documents or records based on embeddings.

Configuring API access for external applications in our case browser to interact with the schema and perform operations.

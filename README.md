# LBEEP V1.0

Linear B-Cell Exact Epitope Predictor

## 1. Introduction

LBEEP (Linear B-Cell Exact Epitope Predictor) is a Perl-based open-source tool for the prediction of Linear B-cell epitopes using Amino Acid Composition-based Feature Descriptors (DDE - Dipeptide Deviation from Expected mean).

Please refer the article titled ["Harnessing Computational Biology for Exact Linear B-Cell Epitope Prediction: A Novel Amino Acid Composition-based Feature Descriptor"](http://online.liebertpub.com/doi/abs/10.1089/omi.2015.0095) for more details.

## 2. Prerequisites

| Requirement | Version |
|-------------|---------|
| Perl | 5.0 or higher |
| Java | 1.6 or higher (for Weka ML classifier) |

## 3. Installation

### Option A: Local Installation

#### Linux

```bash
# 1. Clone or download the repository
git clone https://github.com/IEDB/LBEEP.git
cd LBEEP

# 2. Make the script executable
chmod +x LBEEP

# 3. Create the temp directory (required for intermediate files)
mkdir -p temp

# 4. Verify Perl is installed
perl --version

# 5. Verify Java is installed
java -version
```

#### macOS

```bash
# 1. Install Perl (if not already installed)
# macOS includes Perl by default. To install/update:
brew install perl

# 2. Install Java (required for Weka)
brew install openjdk

# 3. Clone or download the repository
git clone https://github.com/IEDB/LBEEP.git
cd LBEEP

# 4. Make the script executable
chmod +x LBEEP

# 5. Create the temp directory
mkdir -p temp

# 6. Verify installations
perl --version
java -version
```

#### Windows

```bash
# 1. Install Strawberry Perl (includes Perl + essential modules)
# Download from: https://strawberryperl.com/
# During installation, select "Add to PATH"

# 2. Install Java (JDK/JRE)
# Download from: https://www.oracle.com/java/technologies/downloads/
# During installation, select "Set JAVA_HOME variable"

# 3. Clone or download the repository
git clone https://github.com/IEDB/LBEEP.git
cd LBEEP

# 4. Create the temp directory
mkdir temp

# 5. Verify installations (open Command Prompt or PowerShell)
perl --version
java -version
```

> **Windows Note**: LBEEP is primarily tested on Linux. On Windows, run via `perl LBEEP` rather than `./LBEEP`.

---

### Option B: Docker Installation (Recommended)

Docker provides a consistent environment across all platforms without installing Perl or Java manually.

#### Install Docker

| Platform | Installation |
|----------|-------------|
| **Linux** | `curl -fsSL https://get.docker.com \| sh` or install via your package manager |
| **macOS** | Download [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/) |
| **Windows** | Download [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/) (requires WSL 2 or Hyper-V) |

#### Build the Docker Image

```bash
cd LBEEP
docker build -t lbpeak .
```

#### Run with Docker

```bash
# Create input/output directories
mkdir -p input output

# Copy your input files to the input directory
cp test_input_peptides input/

# Run peptide mode
docker run --rm \
  -v "$(pwd)/input:/app/input" \
  -v "$(pwd)/output:/app/output" \
  lbpeak \
  -i /app/input/test_input_peptides \
  -m pep \
  -M B \
  -t 0.6 \
  -o /app/output/results.csv

# Run protein mode
docker run --rm \
  -v "$(pwd)/input:/app/input" \
  -v "$(pwd)/output:/app/output" \
  lbpeak \
  -i /app/input/test_input_protein \
  -m pro \
  -M B \
  -t 0.6 \
  -w 10 \
  -o /app/output/protein_results.csv

# Run protein mode with HTML output
docker run --rm \
  -v "$(pwd)/input:/app/input" \
  -v "$(pwd)/output:/app/output" \
  lbpeak \
  -i /app/input/test_input_protein \
  -m pro \
  -M B \
  -t 0.6 \
  -w 10 \
  -H \
  -o /app/output/protein_results
```

#### Run with Docker Compose

```bash
cd LBEEP

# Place input files in the input/ directory
mkdir -p input output
cp test_input_peptides input/input.fa
cp test_input_protein input/protein.fa

# Run peptide mode
docker compose run --rm lbpeak-pep

# Run protein mode
docker compose run --rm lbpeak-pro
```

## 4. Command Line Options

| Option | Description | Required | Default |
|--------|-------------|----------|---------|
| `-i` | Input file in FASTA format | Yes | - |
| `-m` | Mode: `pep` (peptide) or `pro` (protein) | Yes | - |
| `-M` | Model: `B` (balanced), `O` (original), `C` (confirmed) | No | `B` |
| `-t` | Threshold (0.0 to 1.0) | No | `0.6` |
| `-o` | Output file path | No | `LBEEP_out` |
| `-w` | Window size for protein mode (6-15) | No | `10` |
| `-H` | Generate HTML output (protein mode only) | No | Disabled |

### Model Descriptions

- **B (Balanced)**: Trained on balanced dataset of epitopes and non-epitopes (default)
- **O (Original)**: Trained on original imbalanced dataset
- **C (Confirmed)**: Trained on experimentally confirmed epitopes/non-epitopes (validated by at least 2 studies)

## 5. Output Interpretation

### CSV Output

**Peptide mode** columns:
- `Sno` - Serial number
- `ID|Peptide|` - Header and peptide sequence
- `Score` - Probability score (higher = more likely epitope)

**Protein mode** columns:
- `Position` - Position range in protein (e.g., `1-10`)
- `|Peptide|` - Peptide window sequence
- `Score` - Probability score

### HTML Output (Protein Mode)

When `-H` flag is used, an HTML file is generated with:
- `E` (green) = Epitope (score >= threshold)
- `.` (red) = Non-epitope (score < threshold)
- Hover over positions to see details

### Classification Rule

Peptides with score **>= threshold** (`-t`) are classified as **epitopes**.

## 6. Examples

### Peptide Mode

```bash
# Local (Linux/macOS)
./LBEEP -i test_input_peptides -m pep -M B -t 0.6 -o results_pep

# Local (Windows)
perl LBEEP -i test_input_peptides -m pep -M B -t 0.6 -o results_pep

# Docker
docker run --rm -v "$(pwd)/output:/app/output" lbpeak \
  -i /app/input/input.fa -m pep -M B -t 0.6 -o /app/output/results_pep
```

### Protein Mode

```bash
# Local (Linux/macOS)
./LBEEP -i test_input_protein -m pro -M B -t 0.6 -w 10 -o results_pro

# Local (Windows)
perl LBEEP -i test_input_protein -m pro -M B -t 0.6 -w 10 -o results_pro

# Docker with HTML output
docker run --rm -v "$(pwd)/output:/app/output" lbpeak \
  -i /app/input/protein.fa -m pro -M B -t 0.6 -w 10 -H -o /app/output/results_pro
```

### Using Confirmed Model

```bash
./LBEEP -i test_input_peptides -m pep -M C -o results_confirmed
```

## 7. Input File Format

Input files must be in FASTA format:

```
>Peptide_Header_1
NHNYPPLSLLTF
>Peptide_Header_2
SHDWRLMLSHLQ
```

> **Note**: LBEEP does not validate FASTA format. Ensure your input is properly formatted.

## 8. Limitations

- Peptide length should be between **6 and 15 amino acids** for reliable predictions
- Window size in protein mode should be between **6 and 15**
- Predictions for sequences outside these ranges may be unreliable
- The "Confirmed" model may have different optimal length ranges

## 9. Project Structure

```
LBEEP/
├── LBEEP                          # Main executable
├── source/
│   └── LBEEP.pl                   # Source code
├── dependency/
│   ├── weka.jar                   # Weka ML library
│   └── module/brsaran/DDE.pm     # DDE feature computation module
├── model/
│   ├── BALANCED.model             # Balanced model (default)
│   ├── ORIGINAL.model             # Original model
│   └── CONFIRM.model              # Confirmed model
├── Dockerfile                     # Docker build file
├── docker-compose.yml             # Docker Compose configuration
├── input/                         # Input files directory (for Docker)
├── output/                        # Output files directory (for Docker)
└── test_input_*                   # Example input files
```

## 10. License

LBEEP V1.0 is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation version 3.0 of the License.

This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License contained in the file LICENSE for more details.

## 11. Contact

For queries: brsaran@gmail.com; saravanan.vij@icmr.gov.in

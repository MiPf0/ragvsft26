ine-tuning has evolved from an expensive "brute-force" process into a highly surgical and efficient science. To understand where QLoRA fits, it helps to see the timeline of how we moved from retraining entire models to just tweaking a few "virtual" knobs.

Here is the history of fine-tuning, categorized by the "Era" of efficiency.

---

## 1. The Brute Force Era (2018–2020)

**Method: Full Fine-Tuning (FFT)**

When BERT and GPT-1 first arrived, the standard approach was to take the entire pretrained model and continue training it on a new dataset.

- **How it worked:** Every single weight in the model was updated.
    
- **The Problem:** As models grew from 110 million parameters (BERT) to 175 billion (GPT-3), this became impossible for most people. You needed massive GPU clusters, and you had to save a full, multi-gigabyte copy of the model for every single task (one for medical, one for legal, etc.).
    

---

## 2. The Modular Era (2019–2021)

**Method: Adapters**

Researchers realized they didn't need to change the whole "brain" to learn a new trick. They started inserting small, trainable layers between the existing layers of the model.

- **How it worked:** You freeze the original model and only train these new "Adapter" layers.
    
- **The Problem:** While efficient, they added "latency." Because you added new layers to the sequence, the model actually ran slower during inference (the time it takes to generate an answer).
    

---

## 3. The Prompting Era (2021)

**Methods: Prefix Tuning & Prompt Tuning**

Instead of adding layers _inside_ the model, why not just add a "smart" prefix to the input?

- **How it worked:** You prepend a sequence of continuous, trainable vectors (essentially "virtual tokens") to the input. The model stays frozen; you only train these prefixes.
    
- **The Problem:** They are notoriously difficult to train and often don't perform as well as structural methods like Adapters.
    

---

## 4. The Mathematical Era (2021–2022)

**Method: LoRA (Low-Rank Adaptation)**

Microsoft researchers released LoRA, which is widely considered the "Gold Standard" today.

- **How it worked:** It uses matrix decomposition. Instead of updating a giant weight matrix, it learns two much smaller matrices that, when multiplied together, approximate the change.
    
- **The Win:** It has **zero inference latency** because you can mathematically merge those small matrices back into the main weights once training is done.
    

---

## 5. The Modern Efficiency Era (2023–Present)

**Method: QLoRA & DoRA**

This is where we are now. QLoRA (Quantized LoRA) took the efficiency of LoRA and combined it with extreme memory compression.

- **QLoRA (2023):** As we discussed, this allowed the base model to be squashed into 4-bit precision, making it possible to fine-tune a 70B model on a single hobbyist GPU.
    
- **DoRA (Weight-Decomposed Low-Rank Adaptation, 2024):** The "newest" evolution. It splits the weight updates into "Magnitude" and "Direction," allowing the model to learn even more effectively than standard LoRA, often matching the performance of Full Fine-Tuning.
    

---

### Summary of the Evolution

|**Generation**|**Method**|**Main Benefit**|**Main Downside**|
|---|---|---|---|
|**Gen 1**|Full Fine-Tuning|Maximum Accuracy|Massive Hardware Cost|
|**Gen 2**|Adapters|Task Portability|Slower Inference|
|**Gen 3**|LoRA|Zero Latency / Small Files|Still needs decent VRAM|
|**Gen 4**|**QLoRA**|**Extreme VRAM Savings**|**Slightly Slower Training**|


What is SFT then (supervised Finetuning)?

**SFT (Supervised Fine-Tuning)** is the "what," while **QLoRA** is the "how."

To put it simply: SFT is the **stage** of training, and QLoRA is the **technique** used to perform it efficiently.

---

## 1. Where SFT Fits in the Pipeline

Modern LLMs are usually trained in three distinct phases. SFT is the critical second step that turns a "word predictor" into a "helpful assistant."

1. **Pre-training:** The model reads the entire internet to learn grammar, facts, and reasoning. It becomes a "Base Model." If you ask it "What is the capital of France?", it might respond with "...and what is the capital of Germany?" because it’s just completing a list.
    
2. **Supervised Fine-Tuning (SFT):** You show the model thousands of high-quality examples of **Instruction -> Response** pairs (e.g., "Write a poem about a cat" followed by an actual poem). This teaches the model to follow directions.
    
3. **Alignment (RLHF/DPO):** The model is polished based on human preferences to ensure it isn't rude, dangerous, or prone to hallucinating.
    

---

## 2. The Relationship: SFT vs. QLoRA

Think of SFT as the **curriculum** (the textbook and lessons) and QLoRA as the **notebook** (the tool you use to record the lessons).

- **SFT is the Goal:** You want the model to learn a specific style, format, or knowledge base using a labeled dataset.
    
- **QLoRA is the Engine:** You use QLoRA to actually run that SFT process on your computer without needing $10,000 worth of hardware.
    

---

## 3. What does an SFT dataset look like?

To perform SFT, you need a dataset where a human (or a very smart AI) has provided the "Correct" answer. It usually follows a JSON structure like this:

JSON

```
{
  "instruction": "Explain photosynthesis to a five-year-old.",
  "output": "Plants eat sunlight to make their own food, kind of like how you eat veggies to grow big and strong!"
}
```

When you run **SFT via QLoRA**, the model looks at the "instruction," tries to guess the "output," and the QLoRA adapters are updated based on how wrong the guess was.

---

## 4. Why is SFT so popular right now?

Before QLoRA, doing SFT on a large model (like Llama 3 70B) was reserved for big tech companies. Now, because of QLoRA:

- **Medical SFT:** Doctors can take a base model and fine-tune it on medical journals.
    
- **Coding SFT:** Developers can fine-tune a model on their company’s private codebase.
    
- **Roleplay SFT:** Writers can fine-tune a model to speak exactly like a specific fictional character.
    

### Summary Comparison

| **Term**  | **Category**          | **Definition**                                                             |
| --------- | --------------------- | -------------------------------------------------------------------------- |
| **SFT**   | **Training Phase**    | The process of teaching a model to follow instructions using labeled data. |
| **QLoRA** | **Efficiency Method** | A memory-saving trick that allows you to do SFT on cheap hardware.         |
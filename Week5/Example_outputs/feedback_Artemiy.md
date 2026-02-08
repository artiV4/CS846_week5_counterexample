# Counterexample - Guideline 1: Provide Project-Specific Examples of Code Summaries and Context for functions/files
## 1. Rationale

A caveat for usage of the guideline is the case where the repository contains files with differing levels of access.

If there is an internal file and an API file for it then the LLm can be prone to leaking internal details and creating semantically similar documentation for the two even if the access levels, contexts, and functionalities differ.

In agent mode the LLM might read more than the supplied example documentation.

Thus I propose a new idea as a standalone guideline and an exception to guideline 1.

### Guideline 7:
Enfore strict separation between access levels of files, ideally using separate chats and repositories.

---

## 2. Example Problem

**Task Description:** Generate documentation for the pool.h file in Week5/ExampleProblemA/Artifacts

> A Note on GenAI contribution: Example problem code was partially created using GitHub Copilot Raptor mini



## 3. Documentation: Original Guideline Applied

**Prompt:**

> Our project's documentation style: pool_internal.h
> Document this in pool.h
> void pool_free(MemoryPool* pool, void* ptr);

**LLM Output:**

> /**
> * @brief Returns a previously allocated block to the pool.
> *
> * Returns a block previously obtained via pool_alloc() back to the pool for reuse.
> * If ptr is NULL the function does nothing. This function is thread-safe and
> * will acquire the pool's internal lock when updating pool state.
> *
> * @param pool Memory pool to return the block to (must be initialized via pool_init())
> * @param ptr Pointer previously returned by pool_alloc(), or NULL
> * @return None
> *
> * @pre pool initialized via pool_init(); if non-NULL, ptr must be a pointer
> *      previously returned by pool_alloc() and not already freed
> * @exceptsafe No-throw
> */

**Why this is sub-optimal:**
Though the documentation looks correct it has false details which are copied from pool_internal and do not reflect the true implementation. It also leaks details about the internal file functions through the comment.

---

## 4. Updated Guideline

**Guideline 7: Enfore strict separation between access levels of files, ideally using separate chats and repositories.**

**Description:**

When working with sensitive data: Limit what information the LLM can read and reference when generating a response. Ideally have a repository level separation but at minimum have the prompt reference the fact that the internal file details cannot be leaked.

**Reasoning:**

LLMs tend to go for the easiest answer based on recently read data and thus are prone to repeat the confidential file if there is a pattern that matches between the public facing and private files.

**Example**
Separate repositories for differing levels of access. A note on the sensitivity level of example files.

---

## 5. Documentation: Updated Guideline Applied

**Prompt:**

> Our project's documentation style: pool_internal.h
> Document this in pool.h
> void pool_free(MemoryPool* pool, void* ptr);
> Note that pool_internal.h is an internal file and must not be leaked. Do not copy internal or implementation specific details.

**LLM Output:**

>/**
> * @brief Return a previously allocated block to the pool.
> *
> * The block becomes available for future allocations. If ptr is NULL or does not
> * belong to the specified pool, the function has no effect.
> *
> * @param pool Memory pool to return the block to
> * @param ptr Pointer previously obtained from pool_alloc (may be NULL)
> * @return None
> *
> * @pre pool must be initialized via pool_init()
> * @exceptsafe No-throw guarantee
> */
`

**Result:**
With the added note explaining that pool_internal.h is internal the output documentation does not assume details about the similarly named function and does not leak details about the internal file. The same situation can be observed with a larger example in example_long.txt 

---
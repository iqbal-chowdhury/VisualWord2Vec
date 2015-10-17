// Wrapper around the liblinear library
# ifndef LIBLIN
# define LIBLIN

// Standard libraries
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <math.h>
# include <pthread.h>
# include <ctype.h>

// For liblinear
# include "/home/satwik/VisualWord2Vec/libs/liblinear-1.94/linear.h"
# include "structs.h"
# include "macros.h"


/*****/
// External variables
extern struct Sentence* trainSents;
extern int vpFeatSize;
extern long noTrainVP;
//extern struct

// Setup the training, model, param and other variables liblinear expects,
// in its format
void setupTrainFrameWork();

// Create the problem for the training data
void createProblem(struct Sentence*, long);
// Modifying the problem
void modifyProblem(struct Sentence*, long);
// Creating the parameters
void createParameter();
// Create each training instance
struct feature_node* createFeatureNodeList(struct Sentence, int);
# endif

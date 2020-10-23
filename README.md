This will create an s3 bucket with an added lambda function that will trigger on an object upload. 

Once the lambda is completed, assume the lambda added labels to the object.

Then the policy will check on those labels and publish the objects based on the labels.

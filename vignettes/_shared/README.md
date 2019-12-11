This is where we will place shared code.

Please be _very_ careful editing code in this directory. Similarly, don't add code to this directory until you are sure it has genuine usefulness in multiple vignettes, and you have cleaned up & tested it.

You can use these classes in a vignette by adding a dependency in your pubspec.yaml file:

```
dependencies:
  shared:
    path: ../_shared/
```
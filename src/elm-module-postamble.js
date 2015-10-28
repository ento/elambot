  if (typeof define === "function" && define.amd) {
    define([], function() {
      return Elm;
    });
  } else if (typeof module === "object") {
    module.exports = Elm;
  } else {
    if (typeof this.Elm === "undefined") {
      this.Elm = Elm;
    } else {
      throw new Error("This page is trying to import multiple compiled Elm programs using the same `Elm` global object, which would cause conflicts. This can be resolved by using a module loader like RequireJS to import the compiled Elm programs into different objects.")
    }
  }
}).call(this);

import importPlugin from "eslint-plugin-import";
import reactPlugin from "eslint-plugin-react";
import tseslint from "@typescript-eslint/eslint-plugin";
import tsParser from "@typescript-eslint/parser";

const eslintConfig = [
  {
    ignores: ["vendor/**/*.d.ts"],
  },
  {
    files: [
      "resources/js/**/*.{ts,tsx}",
      "vendor/narsil/cms/resources/js/**/*.{ts,tsx}",
    ],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
        project: "./tsconfig.json",
      },
    },
    plugins: {
      "@typescript-eslint": tseslint,
      import: importPlugin,
      react: reactPlugin,
    },
    rules: {
      // Code quality rules
      eqeqeq: ["warn", "always", { null: "ignore" }],
      "no-eval": "error",
      "no-implied-eval": "error",
      "no-multiple-empty-lines": ["warn", { max: 1, maxEOF: 0, maxBOF: 0 }],
      "no-new-func": "error",
      "no-script-url": "error",
      "no-self-compare": "error",
      "no-throw-literal": "error",
      "no-useless-concat": "warn",
      "no-useless-return": "warn",
      "prefer-arrow-callback": "warn",
      "prefer-destructuring": ["warn", { object: true, array: false }],

      // JavaScript/ES6 rules
      "no-console": "warn",
      "no-debugger": "warn",
      "no-duplicate-imports": "error",
      "no-unused-expressions": "warn",
      "no-var": "error",
      "object-shorthand": "off",
      "prefer-const": "warn",
      "prefer-template": "warn",

      // React rules
      "react/jsx-key": "error",
      "react/jsx-no-duplicate-props": "error",
      "react/jsx-no-undef": "error",
      "react/no-children-prop": "off",
      "react/no-danger-with-children": "error",
      "react/no-deprecated": "warn",
      "react/no-direct-mutation-state": "error",
      "react/no-find-dom-node": "warn",
      "react/no-is-mounted": "error",
      "react/no-render-return-value": "error",
      "react/no-string-refs": "error",
      "react/no-unescaped-entities": "warn",
      "react/no-unknown-property": "error",
      "react/no-unsafe": "warn",
      "react/prop-types": "off",
      "react/react-in-jsx-scope": "off",
      "react/require-render-return": "error",

      // Typescript rules
      "@typescript-eslint/ban-ts-comment": "warn",
      "@typescript-eslint/no-empty-object-type": "warn",
      "@typescript-eslint/no-explicit-any": "warn",
      "@typescript-eslint/no-var-requires": "error",
      "@typescript-eslint/no-unused-vars": [
        "warn",
        {
          vars: "all",
          args: "after-used",
          ignoreRestSiblings: false,
          argsIgnorePattern: "^_",
          varsIgnorePattern: "^_",
          destructuredArrayIgnorePattern: "^_",
          caughtErrorsIgnorePattern: "^(_|ignore)",
        },
      ],
      "import/order": [
        "warn",
        {
          alphabetize: {
            order: "asc",
            caseInsensitive: true,
          },
          groups: [
            "builtin",
            "external",
            "internal",
            ["parent", "sibling", "index"],
            "type",
          ],
          "newlines-between": "always",
          pathGroups: [
            {
              pattern: "@narsil-cms/**",
              group: "internal",
            },
          ],
          pathGroupsExcludedImportTypes: ["react", "react-dom"],
          warnOnUnassignedImports: true,
        },
      ],
    },
    settings: {
      react: {
        version: "detect",
      },
    },
  },
];

export default eslintConfig;

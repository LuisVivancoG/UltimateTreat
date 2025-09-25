using UnityEditor;
using UnityEngine;

public class PrefabReplacer : EditorWindow
{
private GameObject _replacementPrefab;
    private bool _addNumber = true;

    //Toolbar action
    [MenuItem("PersonalTools/Prefab Replacer")]
    
    public static void ShowWindow()
    {
        GetWindow<PrefabReplacer>("Prefab Replacer");
    }

    public void OnGUI()
    {
        GUILayout.Label("Replace Gameobjects with Prefabs", EditorStyles.boldLabel);

        //Select the prefab
        _replacementPrefab = (GameObject)EditorGUILayout.ObjectField("Replacement Prefab", _replacementPrefab, typeof(GameObject), false);

        if(GUILayout.Button("Replace Prefab"))
        {
            ReplacePrefab();
        }
    }

    //Select Our Objects -- Functionality -- Replace with Prefabs

    private void ReplacePrefab()
    {
        if (_replacementPrefab == null)
        {
            Debug.LogWarning("No Prefab Selected");
        }

        var selectedObjects = Selection.gameObjects;

        var prefabType = PrefabUtility.GetPrefabAssetType(_replacementPrefab);

        for (int i = 0; i < selectedObjects.Length; i++)
        {
            GameObject newObject = null;
            var oldParent = selectedObjects[i].gameObject.transform.parent;

            string name = _addNumber ? $"{_replacementPrefab.name}{" ("}{i + 1}{")"}" : $"{_replacementPrefab.name}";

            if (prefabType == PrefabAssetType.Regular)
            {
                newObject = (GameObject)PrefabUtility.InstantiatePrefab(_replacementPrefab, oldParent);

                Undo.RegisterCreatedObjectUndo(newObject, "New object");
            }

            else
            {
                newObject = (GameObject)PrefabReplacer.Instantiate(_replacementPrefab, oldParent);

                Undo.RegisterCreatedObjectUndo(newObject, "New object");
            }
            newObject.transform.position = selectedObjects[i].transform.position;
            newObject.transform.rotation = selectedObjects[i].transform.rotation;
            newObject.transform.localScale = selectedObjects[i].transform.localScale;

            newObject.name = name;

            Undo.DestroyObjectImmediate(selectedObjects[i]);
        }
        Debug.Log("Meshes Replaced");
    }
}

using UnityEditor;
using UnityEngine;

public class RenamerUtil : EditorWindow
{
    private string _prefix = "Prefix_";
    private string _sufix = "_sufix";
    private bool _addNumbering = true;

    [MenuItem("PersonalTools/Renamer")]

    // Create window
    public static void ShowWindow()
    {
        GetWindow<RenamerUtil>("Rename Tool Kit");
    }

    // Button to access

    private void OnGUI()
    {
        GUILayout.Label("Rename options");

        _prefix = EditorGUILayout.TextField("Enter Prefix", _prefix);

        if (GUILayout.Button("Assign new prefix"))
        {
            //Call function
            AddPrefix();
        }

        _sufix = EditorGUILayout.TextField("Enter Suffix", _sufix);

        if (GUILayout.Button("Assign new suffix"))
        {
            //Call function
            AddSuffix();
        }
    }

    // Button activity
    private void AddPrefix()
    {
        //Getting the selected objects
        var selectedObjects = Selection.objects;
        for (int i = 0; i < selectedObjects.Length; i++)
        {
            //Running a loop over selected objects and renaming them
            string newName = _addNumbering ? $"{_prefix}{selectedObjects[i].name}{i + 1}" : $"{_prefix}{selectedObjects[i].name}";
            selectedObjects[i].name = newName;
        }
    }
    private void AddSuffix()
    {
        //Getting the selected objects
        var selectedObjects = Selection.objects;
        for (int i = 0; i < selectedObjects.Length; i++)
        {
            //Running a loop over selected objects and renaming them
            string newName = _addNumbering ? $"{selectedObjects[i].name}{_sufix}" : $"{selectedObjects[i].name}{_sufix}";
            selectedObjects[i].name = newName;
        }
    }

    //
}

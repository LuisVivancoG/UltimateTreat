using UnityEditor;
using UnityEngine;

//[CustomEditor(typeof(ItemData))]
//public class ItemDataEditor : Editor
//{
//    public override void OnInspectorGUI()
//    {
//        // Get reference to the target object (ItemData)
//        ItemData itemData = (ItemData)target;

//        EditorGUI.BeginChangeCheck();

//        // Draw default fields
//        DrawDefaultInspector();

//        // Display _speed field only if _isProjectile is true
//        switch (itemData.TypeOfItem)
//        {
//            case ItemData.ItemType.None:
//                break;

//            case ItemData.ItemType.BasicProjectile:
//                EditorGUILayout.LabelField("Projectile Settings", EditorStyles.boldLabel);
//                itemData.HPModifier = EditorGUILayout.FloatField("Damage points", itemData.HPModifier);
//                itemData.IsProjectile = EditorGUILayout.Toggle("is it a projectile?", itemData.IsProjectile);
//                if (itemData.IsProjectile)
//                {
//                    itemData.Speed = EditorGUILayout.FloatField("Projectile Speed", itemData.Speed);
//                }
//                itemData.ReuseCooldown = EditorGUILayout.FloatField("firerate", itemData.ReuseCooldown);
//                break;

//            case ItemData.ItemType.RapidFire:
//                EditorGUILayout.LabelField("Projectile Settings", EditorStyles.boldLabel);
//                itemData.HPModifier = EditorGUILayout.FloatField("Damage points", itemData.HPModifier);
//                itemData.IsProjectile = EditorGUILayout.Toggle("is it a projectile?", itemData.IsProjectile);
//                if (itemData.IsProjectile)
//                {
//                    itemData.Speed = EditorGUILayout.FloatField("Projectile Speed", itemData.Speed);
//                }
//                itemData.IsSingleUse = EditorGUILayout.Toggle("is it single use?", itemData.IsSingleUse);
//                if (!itemData.IsSingleUse)
//                {
//                    itemData.ReuseCooldown = EditorGUILayout.FloatField("firerate", itemData.ReuseCooldown);
//                }
//                break;

//            case ItemData.ItemType.BigMissile:
//                EditorGUILayout.LabelField("Projectile Settings", EditorStyles.boldLabel);
//                itemData.HPModifier = EditorGUILayout.FloatField("Damage points", itemData.HPModifier);
//                itemData.IsProjectile = EditorGUILayout.Toggle("is it a projectile?", itemData.IsProjectile);
//                if (itemData.IsProjectile)
//                {
//                    itemData.Speed = EditorGUILayout.FloatField("Projectile Speed", itemData.Speed);
//                }
//                itemData.IsSingleUse = EditorGUILayout.Toggle("is it single use?", itemData.IsSingleUse);
//                if (!itemData.IsSingleUse)
//                {
//                    itemData.ReuseCooldown = EditorGUILayout.FloatField("firerate", itemData.ReuseCooldown);
//                }
//                break;

//            case ItemData.ItemType.HealthPack:
//                itemData.HPModifier = EditorGUILayout.FloatField("Heal points", itemData.HPModifier);
//                break;
//        }

//        // Save changes made in the Inspector
//        if (EditorGUI.EndChangeCheck())
//        {
//            Undo.RecordObject(itemData, "Modified Item Data");
//            EditorUtility.SetDirty(itemData);
//            AssetDatabase.SaveAssets();
//        }
//    }
//}

//
//  CoreDataManager.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 14.12.25.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    lazy private var persistanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PhotoEntity")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistanceContainer.viewContext
    }
    
    private func save() throws(DatabaseError) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                throw .saveError(error)
            }
        }
    }
    
    func savePhotoModel(model: DatabasePhotoModel) throws(DatabaseError) {
        
        let fetchRequest = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", model.id)
        
        do {
            if let _ = try context.fetch(fetchRequest).first { return }
        } catch let error {
            throw .fetchError(error)
        }
        
        let photo = PhotoEntity(context: context)
        photo.id = model.id
        photo.imageDescription = model.description
        photo.likes = Int32(model.likes)
        photo.regularUrl = model.regularUrl
        photo.thumbUrl =  model.thumbUrl
        photo.username = model.username
        try save()
    }
    
    func fetchPhotosModels(page: Int) throws(AppError) -> [ImageModel] {
        let offset = (page - 1) * APIEndpoints.imagesPerPage
        let limit = APIEndpoints.imagesPerPage
        let fetchRequest = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        fetchRequest.fetchLimit = limit
        fetchRequest.fetchOffset = offset
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "likes", ascending: false)]
        do {
            return try context.fetch(fetchRequest).map({ toImageModel(photoEntity: $0) })
        } catch let error {
            throw .databaseError(.fetchError(error))
        }
    }
    
    func deletePhoto(id: String) throws(DatabaseError) {
        let fetchRequest = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            if let photo = try context.fetch(fetchRequest).first {
                context.delete(photo)
            }
        } catch let error {
            throw .fetchError(error)
        }
        
        try save()
    }
    
    func isPhotoLiked(id: String) throws(DatabaseError) -> Bool {
        let fetchRequest = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            if let _ = try context.fetch(fetchRequest).first { return true }
        } catch let error {
            throw .fetchError(error)
        }
        return false
    }
}

extension CoreDataManager {
    func toImageModel(photoEntity: PhotoEntity) -> ImageModel {
        ImageModel(
            id: photoEntity.id!,
            width: nil,
            height: nil,
            createdDate: nil,
            description: photoEntity.imageDescription,
            altDescription: nil,
            photoUrls: .init(
                raw: nil,
                regular: photoEntity.regularUrl!,
                thumb: photoEntity.thumbUrl!
            ),
            likes: Int(photoEntity.likes),
            user: .init(username: nil, instagramUsername: photoEntity.username)
        )
    }
    
   
}

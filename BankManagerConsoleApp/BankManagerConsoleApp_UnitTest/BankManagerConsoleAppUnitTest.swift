//
//  BankManagerConsoleAppUnitTest.swift
//  BankManagerConsoleAppUnitTest
//
//  Created by 강창현 on 1/22/24.
//

@testable import BankManagerConsoleApp
import XCTest

final class BankManagerConsoleAppUnitTest: XCTestCase {
    private var sut: Queue<String>!
    
    override func setUp() {
        self.sut = Queue()
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Peek
    func test_Queue의_headNode는_kyle이고_nextNode가_effie일때_peek는_kyle이다() {
        // Given
        let nextNode = Node(data: "effie", next: nil)
        let head = Node(data: "kyle", next: nextNode)
        self.sut = Queue(linkedList: .init(head: head))
        
        // When
        let result = sut.peek
        
        // Then
        XCTAssertEqual(result, "kyle")
    }
    
    // MARK: - isEmpty
    func test_Queue의_headNode는_kyle이고_nextNode가_effie일때_isEmpty는_false이다() {
        // Given
        let nextNode = Node(data: "effie", next: nil)
        let head = Node(data: "kyle", next: nextNode)
        self.sut = Queue(linkedList: .init(head: head))
        
        // When
        let result = sut.isEmpty
        
        // Then
        XCTAssertFalse(result)
    }
    
    // MARK: - Dequeue
    func test_Queue의_headNode는_kyle이고_nextNode가_effie일때_dequeue는_kyle이다() {
        // Given
        let nextNode = Node(data: "effie", next: nil)
        let head = Node(data: "kyle", next: nextNode)
        self.sut = Queue(linkedList: .init(head: head))
        
        // When
        let result = self.sut.dequeue()
        
        // Then
        XCTAssertEqual(result, "kyle")
    }
    
    // MARK: - Enqueue
    func test_Queue에_headNode가_kyle이고_nextNode가_nil일때_effie를_enqueue_하면_nextNode는_effie이다() {
        // Given
        let head = Node(data: "kyle", next: nil)
        self.sut = Queue(linkedList: .init(head: head))
        
        // When
        sut.enqueue("effie")
        var result: String?
        while self.sut.peek != nil {
            result = self.sut.dequeue()
        }
        
        // Then
        XCTAssertEqual(result, "effie")
    }
    
    // MARK: - Clear
    func test_Queue의_headNode는_kyle이고_nextNode가_effie일때_clear는_head가_nil이다() {
        // Given
        let nextNode = Node(data: "effie", next: nil)
        let head = Node(data: "kyle", next: nextNode)
        self.sut = Queue(linkedList: .init(head: head))
        
        // When
        sut.clear()
        let result = sut.peek
        
        // Then
        XCTAssertNil(result)
    }
}

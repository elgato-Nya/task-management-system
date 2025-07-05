@if ($paginator->hasPages())
    <nav class="d-flex justify-content-center" aria-label="Page navigation">
        <ul class="pagination pagination-custom mb-0">
            {{-- Previous Page Link --}}
            @if ($paginator->onFirstPage())
                <li class="page-item disabled" aria-disabled="true">
                    <span class="page-link" title="Previous page">
                        <i class="fas fa-chevron-left"></i>
                        <span class="d-none d-md-inline ms-1">Previous</span>
                    </span>
                </li>
            @else
                <li class="page-item">
                    <a class="page-link" href="{{ $paginator->previousPageUrl() }}" rel="prev" title="Previous page">
                        <i class="fas fa-chevron-left"></i>
                        <span class="d-none d-md-inline ms-1">Previous</span>
                    </a>
                </li>
            @endif

            {{-- Pagination Elements --}}
            @foreach ($elements as $element)
                {{-- "Three Dots" Separator --}}
                @if (is_string($element))
                    <li class="page-item disabled" aria-disabled="true">
                        <span class="page-link">{{ $element }}</span>
                    </li>
                @endif

                {{-- Array Of Links --}}
                @if (is_array($element))
                    @foreach ($element as $page => $url)
                        @if ($page == $paginator->currentPage())
                            <li class="page-item active" aria-current="page">
                                <span class="page-link" title="Current page">{{ $page }}</span>
                            </li>
                        @else
                            <li class="page-item">
                                <a class="page-link" href="{{ $url }}" title="Go to page {{ $page }}">{{ $page }}</a>
                            </li>
                        @endif
                    @endforeach
                @endif
            @endforeach

            {{-- Next Page Link --}}
            @if ($paginator->hasMorePages())
                <li class="page-item">
                    <a class="page-link" href="{{ $paginator->nextPageUrl() }}" rel="next" title="Next page">
                        <span class="d-none d-md-inline me-1">Next</span>
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </li>
            @else
                <li class="page-item disabled" aria-disabled="true">
                    <span class="page-link" title="Next page">
                        <span class="d-none d-md-inline me-1">Next</span>
                        <i class="fas fa-chevron-right"></i>
                    </span>
                </li>
            @endif
        </ul>
    </nav>

    {{-- Results info --}}
    <div class="d-flex justify-content-center mt-3">
        <small class="text-muted d-flex align-items-center">
            <i class="fas fa-info-circle me-2"></i>
            <span>
                Showing 
                <strong>{{ $paginator->firstItem() }}</strong> 
                to 
                <strong>{{ $paginator->lastItem() }}</strong> 
                of 
                <strong>{{ number_format($paginator->total()) }}</strong> 
                {{ Str::plural('task', $paginator->total()) }}
            </span>
        </small>
    </div>
@endif
